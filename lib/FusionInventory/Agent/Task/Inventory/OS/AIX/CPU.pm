package FusionInventory::Agent::Task::Inventory::OS::AIX::CPU;

use strict;
use warnings;

sub isInventoryEnabled {
    return 1;
}


sub doInventory {
    my (%params) = @_;

    my $inventory = $params{inventory};
    my $logger    = $params{logger};

    foreach my $cpu (_getCPUs(
        command => 'lsdev -Cc processor -F name',
        logger  => $logger
    )) {
        $inventory->addEntry(
            section => 'CPUS',
            entry   => $cpu
        );
    }
}

sub _getCPUs {
    my $handle = getFileHandle(@_);
    return unless $handle;

    my $aixversion = getFirstLine(command => 'uname -v');

    my @cpus;
    while (my $line = <$handle>) {
        chomp $line;
        my $device = $line;

        my $format = $aixversion >= 5 ?
            'type:frequency:smt_threads' : 'type';

        my @lsattr = getAllLines(
            command => "lsattr -EOl $device -a '$format'",
        );

        # drop headers
        shift @lsattr;
        
        # use first line to compute name, frequency and number of threads
        my @infos = split(/:/, $lsattr[0]);
        my $cpu = {
            THREAD => 1
        };

        $cpu->{NAME} = $infos[0];
        $cpu->{NAME} =~ s/_/ /;

        if ($aixversion >= 5) {
            $cpu->{THREAD} = $infos[2];
            $cpu->{SPEED} = ($infos[1] % 1000000) >= 50000 ? 
                int($infos[1] / 1000000) + 1 : int($infos[1] / 1000000);
        } else {
            # On older models, frequency is based on cpu model and uname
            SWITCH: {
                if (
                    $infos[0] eq "PowerPC"     or
                    $infos[0] eq "PowerPC_601" or
                    $infos[0] eq "PowerPC_604"
                ) {
                    my $uname = getFirstLine(command => 'uname -m');
                    $cpu->{SPEED} =
                        $uname =~ /E1D|EAD|C1D|R04|C4D|R4D/ ?  12.2 :
                        $uname =~ /34M/                     ? 133   :
                        $uname =~ /N4D/                     ? 150   :
                        $uname =~ /X4M|X4D/                 ? 200   :
                        $uname =~ /N4E|K04|K44/             ? 225   :
                        $uname =~ /N4F/                     ? 320   :
                        $uname =~ /K45/                     ? 360   :
                                                              undef ;
                    last SWITCH;
                }

                if ($infos[0] eq "PowerPC_RS64_III") {
                    $cpu->{SPEED} = 400;
                    last SWITCH;
                }

                if ($infos[0] eq "PowerPC_620") {
                    $cpu->{SPEED} = 172;
                    last SWITCH;
                }

                $cpu->{SPEED} = 225;
            }
        }

        # compute core number from lines number
        $cpu->{CORE} = scalar @lsattr;

        push @cpus, $cpu;
    }
    close $handle;

    return @cpus;
}

1;
