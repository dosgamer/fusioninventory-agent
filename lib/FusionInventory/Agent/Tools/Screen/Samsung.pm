package FusionInventory::Agent::Tools::Screen::Samsung;

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

    my $serial1 = $self->{edid}->{serial_number};
    my $serial2 = $self->{edid}->{serial_number2}->[0]
        or return '';

    return
        chr(($serial1 >> 24)% 256) .
        chr(($serial1 >> 16)% 256) .
        chr(($serial1 >> 8 )% 256) .
        chr( $serial1       % 256) .
        $serial2 ;
}

1;
