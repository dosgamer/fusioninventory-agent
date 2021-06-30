package FusionInventory::Agent::Tools::Screen::Acer;

use strict;
use warnings;

use parent 'FusionInventory::Agent::Tools::Screen';

sub serial {
    my ($self) = @_;

    return $self->fullserial;
}

sub altserial {
    my ($self) = @_;

    return $self->{_serial} if $self->{_serial};
}

sub fullserial {
    my ($self) = @_;

    my $serial1 = sprintf("%08x", $self->{edid}->{serial_number});
    my $serial2 = $self->{edid}->{serial_number2}->[0];

    # fix date in serial number
    if (substr($serial1,0,4) eq "0000") {
        my $year1 = substr($self->{edid}->{year},3,1);
        my $week1 = sprintf("%02d", $self->{edid}->{week});
        $serial1 = $year1.$week1."0".substr($serial1,4,4);
    }

    return $serial1 if !$serial2;

    # Split serial2
    my $part1 = substr($serial2, 0, 8);
    my $part2 = substr($serial2, 8, 4);

    # Assemble serial1 with serial2 parts
    return $part1 . $serial1 . $part2;
}

1;
