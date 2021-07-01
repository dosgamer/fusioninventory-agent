#!/usr/bin/perl

use strict;
use warnings;

use English qw(-no_match_vars);
use Test::Deep qw(cmp_deeply);
use Test::More;
use UNIVERSAL::require;

use FusionInventory::Agent::Tools;
use FusionInventory::Agent::Task::Inventory::Generic::Screen;

plan(skip_all => 'Parse::EDID >= 1.0.4 required')
    unless Parse::EDID->require('1.0.4');

Test::NoWarnings->use();

my %edid_tests = (
    'crt.13' => {
        MANUFACTURER => 'Litronic Inc',
        MODEL        => 'A1554NEL',
        CAPTION      => 'A1554NEL',
        SERIAL       => '926750447',
        DESCRIPTION  => '26/1999'
    },
    'crt.dell-d1626ht' => {
        MANUFACTURER => 'Dell Inc.',
        MODEL        => 'DELL D1626HT',
        CAPTION      => 'DELL D1626HT',
        SERIAL       => '55347B06Z418',
        DESCRIPTION  => '4/1998'
    },
    'crt.dell-p1110' => {
        MANUFACTURER => 'Dell Inc.',
        MODEL        => 'DELL P1110',
        CAPTION      => 'DELL P1110',
        SERIAL       => '9171RB0JCW89',
        DESCRIPTION  => '35/1999'
    },
    'crt.dell-p790' => {
        MANUFACTURER => 'Dell Inc.',
        MODEL        => 'DELL P790',
        CAPTION      => 'DELL P790',
        SERIAL       => '8757RH9QUY80',
        DESCRIPTION  => '33/2000'
    },
    'crt.dell-p190s' => {
        MANUFACTURER => 'Dell Inc.',
        MODEL        => 'DELL P190S',
        CAPTION      => 'DELL P190S',
        SERIAL       => 'CHRYK07UAGUS',
        DESCRIPTION  => '30/2010'
    },
    'crt.dell-e190s' => {
        MANUFACTURER => 'Dell Inc.',
        MODEL        => 'DELL E190S',
        CAPTION      => 'DELL E190S',
        SERIAL       => 'G448N08G0RYS',
        DESCRIPTION  => '34/2010'
    },
    'crt.E55' => {
        MANUFACTURER => 'Panasonic Industry Company',
        MODEL        => undef,
        CAPTION      => undef,
        SERIAL       => '000018a6',
        DESCRIPTION  => '10/1999'
    },
    'crt.emc0313' => {
        MANUFACTURER => 'eMicro Corporation',
        MODEL        => '0000000000011',
        CAPTION      => '0000000000011',
        SERIAL       => '0000198a',
        DESCRIPTION  => '21/2001'
    },
    'crt.hyundai-ImageQuest-L70S+' => {
        MANUFACTURER => 'IMAGEQUEST Co., Ltd',
        MODEL        => 'L70S+',
        CAPTION      => 'L70S+',
        SERIAL       => '0000e0eb',
        DESCRIPTION  => '44/2004'
    },
    'crt.iiyama-1451' => {
        MANUFACTURER => 'Iiyama North America',
        MODEL        => 'LS902U',
        CAPTION      => 'LS902U',
        SERIAL       => '0001f7be',
        DESCRIPTION  => '3/2003'
    },
    'crt.iiyama-404' => {
        MANUFACTURER => 'Iiyama North America',
        MODEL        => '   ',
        CAPTION      => undef,
        SERIAL       => '00000000',
        DESCRIPTION  => '52/1999'
    },
    'crt.iiyama-410pro' => {
        MANUFACTURER => 'Iiyama North America',
        MODEL        => '   ',
        CAPTION      => undef,
        SERIAL       => '00000000',
        DESCRIPTION  => '38/2000'
    },
    'crt.leia' => {
        MANUFACTURER => 'Compaq Computer Company',
        MODEL        => 'COMPAQ P710',
        CAPTION      => 'COMPAQ P710',
        SERIAL       => '047ch67ha005',
        DESCRIPTION  => '47/2000'
    },
    'crt.LG-Studioworks-N2200P' => {
        MANUFACTURER => 'Goldstar Company Ltd',
        MODEL        => 'Studioworks N 2200P',
        CAPTION      => 'Studioworks N 2200P',
        SERIAL       => '0000ce6e',
        ALTSERIAL    => '1J846',
        DESCRIPTION  => '10/2004'
    },
    'crt.med2914' => {
        MANUFACTURER => 'Messeltronik Dresden GmbH',
        MODEL        => undef,
        CAPTION      => undef,
        SERIAL       => '108371572',
        DESCRIPTION  => '8/2001'
    },
    'crt.nokia-valuegraph-447w' => {
        MANUFACTURER => 'Nokia Display Products',
        MODEL        => undef,
        CAPTION      => undef,
        SERIAL       => '00000d1b',
        DESCRIPTION  => '6/1997'
    },
    'crt.SM550S' => {
        MANUFACTURER => 'Samsung Electric Company',
        MODEL        => undef,
        CAPTION      => undef,
        SERIAL       => 'DP15HXAKB13419',
        ALTSERIAL    => 'HXAKB13419',
        DESCRIPTION  => '48/1999'
    },
    'crt.SM550V' => {
        MANUFACTURER => 'Samsung Electric Company',
        MODEL        => 'S/M 550v',
        CAPTION      => 'S/M 550v',
        SERIAL       => 'DP15HXBN407938',
        ALTSERIAL    => 'HXBN407938',
        DESCRIPTION  => '16/2000'
    },
    'crt.sony-gdm400ps' => {
        MANUFACTURER => 'Sony Corporation',
        MODEL        => 'GDM-400PST9',
        CAPTION      => 'GDM-400PST9',
        SERIAL       => '6005379',
        DESCRIPTION  => '39/1999'
    },
    'crt.sony-gdm420' => {
        MANUFACTURER => 'Sony Corporation',
        MODEL        => 'CPD-G420',
        CAPTION      => 'CPD-G420',
        SERIAL       => '6017706',
        DESCRIPTION  => '39/2001'
    },
    'crt.test_box_lmontel' => {
        MANUFACTURER => 'Compaq Computer Company',
        MODEL        => 'COMPAQ MV920',
        CAPTION      => 'COMPAQ MV920',
        SERIAL       => '008GA23MA966',
        DESCRIPTION  => '8/2000'
    },
    'lcd.20inches' => {
        MANUFACTURER => 'Rogen Tech Distribution Inc',
        MODEL        => 'B102005',
        CAPTION      => 'B102005',
        SERIAL       => '0000033f',
        DESCRIPTION  => '52/2004'
    },
    'iiyama-PL2779A' => {
        MANUFACTURER => 'Iiyama North America',
        MODEL        => 'PL2779Q',
        CAPTION      => 'PL2779Q',
        SERIAL       => '01010101',
        DESCRIPTION  => '2013'
    },
    'lcd.acer-al1921' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer AL1921',
        CAPTION      => 'Acer AL1921',
        SERIAL       => 'ETL25080445001d943',
        ALTSERIAL    => 'ETL2508043',
        DESCRIPTION  => '45/2004'
    },
    'lcd.acer-al19161.1' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer AL1916',
        CAPTION      => 'Acer AL1916',
        SERIAL       => 'L4908669719030c64237',
        ALTSERIAL    => 'L49086694237',
        DESCRIPTION  => '19/2007'
    },
    'lcd.acer-al19161.2' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer AL1916',
        CAPTION      => 'Acer AL1916',
        SERIAL       => 'L49086697190328f4237',
        ALTSERIAL    => 'L49086694237',
        DESCRIPTION  => '19/2007'
    },
    'lcd.acer-al19161.3' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer AL1916',
        CAPTION      => 'Acer AL1916',
        SERIAL       => 'L4908669719032914237',
        ALTSERIAL    => 'L49086694237',
        DESCRIPTION  => '19/2007'
    },
    'lcd.acer-al19161.4' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer AL1916',
        CAPTION      => 'Acer AL1916',
        SERIAL       => 'L4908669719032904237',
        ALTSERIAL    => 'L49086694237',
        DESCRIPTION  => '19/2007'
    },
    'lcd.acer-asp1680' => {
        MANUFACTURER => 'Quanta Display Inc.',
        MODEL        => 'JPN4A1P049605 QD15TL021',
        CAPTION      => 'JPN4A1P049605 QD15TL021',
        SERIAL       => '00000000',
        DESCRIPTION  => '51/2004'
    },
    'lcd.acer-v193.1' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer V193',
        CAPTION      => 'Acer V193',
        SERIAL       => 'LBZ081610080b6974233',
        ALTSERIAL    => 'LBZ081614233',
        DESCRIPTION  => '8/2010'
    },
    'lcd.acer-b226hql' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer B226HQL',
        CAPTION      => 'Acer B226HQL',
        SERIAL       => 'LXPEE01452707f0c4202',
        ALTSERIAL    => 'LXPEE0144202',
        DESCRIPTION  => '27/2015'
    },
    'lcd.acer-b226hql.28.2016' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'B226HQL',
        CAPTION      => 'B226HQL',
        SERIAL       => 'LXYEE011628087078507',
        ALTSERIAL    => 'LXYEE0118507',
        DESCRIPTION  => '28/2016'
    },
    'lcd.acer-b196hql' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer B196HQL',
        CAPTION      => 'Acer B196HQL',
        SERIAL       => 'TAHEE00173205d434200',
        ALTSERIAL    => 'TAHEE0014200',
        DESCRIPTION  => '32/2017'
    },
    'lcd.acer-g227hql' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'G227HQL',
        CAPTION      => 'G227HQL',
        SERIAL       => 'T0LEE0145350147f2431',
        ALTSERIAL    => 'T0LEE0142431',
        DESCRIPTION  => '35/2015'
    },
    'lcd.acer-g236hl' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer G236HL',
        CAPTION      => 'Acer G236HL',
        SERIAL       => 'LVB080013127cc394200',
        ALTSERIAL    => 'LVB080014200',
        DESCRIPTION  => '12/2013'
    },
    'prj.acer-p1283' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer P1283',
        CAPTION      => 'Acer P1283',
        SERIAL       => 'JHG11001523014305900',
        ALTSERIAL    => 'JHG110015900',
        DESCRIPTION  => '23/2015'
    },
    'lcd.acer-r221q' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'R221Q',
        CAPTION      => 'R221Q',
        SERIAL       => 'T6KEE00160303ff52400',
        ALTSERIAL    => 'T6KEE0012400',
        DESCRIPTION  => '3/2016'
    },
    'lcd.acer-s273hl' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'S273HL',
        CAPTION      => 'S273HL',
        SERIAL       => 'LQA0C015140000358001',
        ALTSERIAL    => 'LQA0C0158001',
        DESCRIPTION  => '40/2011'
    },
    'lcd.acer-v193.2' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer V193',
        CAPTION      => 'Acer V193',
        SERIAL       => 'LBZ081610050c5b24233',
        ALTSERIAL    => 'LBZ081614233',
        DESCRIPTION  => '5/2010'
    },
    'lcd.acer-ka240hq' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer KA240HQ',
        CAPTION      => 'Acer KA240HQ',
        SERIAL       => 'T3SEE0058040f0164206',
        ALTSERIAL    => 'T3SEE0054206',
        DESCRIPTION  => '4/2018'
    },
    'lcd.acer-x193hq' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'X193HQ',
        CAPTION      => 'X193HQ',
        SERIAL       => 'LEK0D09994003c0c8545',
        ALTSERIAL    => 'LEK0D0998545',
        DESCRIPTION  => '40/2009'
    },
    'prj.acer-x128h' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer X128H',
        CAPTION      => 'Acer X128H',
        SERIAL       => 'JQ811001746013265900',
        ALTSERIAL    => 'JQ8110015900',
        DESCRIPTION  => '46/2017'
    },
    'lcd.acer-v246hl' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer V246HL',
        CAPTION      => 'Acer V246HL',
        SERIAL       => 'LXMEE02080905d6c4222',
        ALTSERIAL    => 'LXMEE0204222',
        DESCRIPTION  => '9/2018'
    },
    'lcd.acer-v193.3' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'V193',
        CAPTION      => 'V193',
        SERIAL       => 'LHW0D03093901df58531',
        ALTSERIAL    => 'LHW0D0308531',
        DESCRIPTION  => '39/2009'
    },
    'lcd.acer-b243h' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'B243H',
        CAPTION      => 'B243H',
        SERIAL       => 'LH30C0109500722b40D1',
        ALTSERIAL    => 'LH30C01040D1',
        DESCRIPTION  => '50/2009'
    },
    'lcd.acer-v243h' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'V243H',
        CAPTION      => 'V243H',
        SERIAL       => 'LFV0C00391105c5a4030',
        ALTSERIAL    => 'LFV0C0034030',
        DESCRIPTION  => '11/2009'
    },
    'lcd.acer-h226hql' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer H226HQL',
        CAPTION      => 'Acer H226HQL',
        SERIAL       => 'LX2EE0023497a1aa4200',
        ALTSERIAL    => 'LX2EE0024200',
        DESCRIPTION  => '49/2013'
    },
    'prj.acer-h6517abd' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'Acer H6517ABD',
        CAPTION      => 'Acer H6517ABD',
        SERIAL       => 'JNB11001911005f25900',
        ALTSERIAL    => 'JNB110015900',
        DESCRIPTION  => '11/2019'
    },
    'lcd.acer-k222hql' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'K222HQL',
        CAPTION      => 'K222HQL',
        SERIAL       => 'T5XEE017725050102456',
        ALTSERIAL    => 'T5XEE0172456',
        DESCRIPTION  => '25/2017'
    },
    'lcd.acer-sa220q' => {
        MANUFACTURER => 'Acer Technologies',
        MODEL        => 'SA220Q',
        CAPTION      => 'SA220Q',
        SERIAL       => 'T90EE00273901d732410',
        ALTSERIAL    => 'T90EE0022410',
        DESCRIPTION  => '39/2017'
    },
    'lcd.b-101750' => {
        MANUFACTURER => 'Rogen Tech Distribution Inc',
        MODEL        => 'B_101750',
        CAPTION      => 'B_101750',
        SERIAL       => '00000219',
        DESCRIPTION  => '6/2004'
    },
    'lcd.benq-t904' => {
        MANUFACTURER => 'BenQ Corporation',
        MODEL        => 'BenQ T904',
        CAPTION      => 'BenQ T904',
        SERIAL       => '0000197a',
        DESCRIPTION  => '15/2004'
    },
    'lcd.blino' => {
        MANUFACTURER => 'AU Optronics',
        MODEL        => 'AUO B150PG01',
        CAPTION      => 'AUO B150PG01',
        SERIAL       => '00000291',
        DESCRIPTION  => '35/2004'
    },
    'lcd.cmc-17-AD' => {
        MANUFACTURER => 'Chi Mei Optoelectronics corp.',
        MODEL        => 'CMC 17" AD',
        CAPTION      => 'CMC 17" AD',
        SERIAL       => '00000000',
        DESCRIPTION  => '34/2004'
    },
    'lcd.compaq-evo-n1020v' => {
        MANUFACTURER => 'LGP',
        MODEL        => undef,
        CAPTION      => undef,
        SERIAL       => '00000000',
        DESCRIPTION  => '0/1990'
    },
    'lcd.dell-2001fp' => {
        MANUFACTURER => 'Dell Inc.',
        MODEL        => 'DELL 2001FP',
        CAPTION      => 'DELL 2001FP',
        SERIAL       => 'C064652L3KTL',
        DESCRIPTION  => '9/2005'
    },
    'lcd.dell-inspiron-6400' => {
        MANUFACTURER => 'LG Philips',
        MODEL        => 'XD570',
        CAPTION      => 'XD570',
        SERIAL       => '00000000',
        DESCRIPTION  => '0/2005',
    },
    'lcd.dell-U2410' => {
        MANUFACTURER => 'Dell Inc.',
        MODEL        => 'DELL U2410',
        CAPTION      => 'DELL U2410',
        SERIAL       => 'F525M1AGAP6L',
        DESCRIPTION  => '42/2011'
    },
    'lcd.dell-U2413' => {
        MANUFACTURER => 'Dell Inc.',
        MODEL        => 'DELL U2413',
        CAPTION      => 'DELL U2413',
        SERIAL       => '84K96386ACRL',
        DESCRIPTION  => '32/2013'
    },
    'lcd.dell-U2415' => {
        MANUFACTURER => 'Dell Inc.',
        MODEL        => 'DELL U2415',
        CAPTION      => 'DELL U2415',
        SERIAL       => '7MT019AI34EU',
        DESCRIPTION  => '42/2019'
    },
    'lcd.eizo-l997' => {
        MANUFACTURER => 'Eizo Nanao Corporation',
        MODEL        => 'L997',
        CAPTION      => 'L997',
        SERIAL       => '21211015',
        DESCRIPTION  => '5/2005'
    },
    'lcd.Elonex-PR600' => {
        MANUFACTURER => 'Chi Mei Optoelectronics corp.',
        MODEL        => 'N154I2-L02 CMO N154I2-L02',
        CAPTION      => 'N154I2-L02 CMO N154I2-L02',
        SERIAL       => '00000000',
        DESCRIPTION  => '9/2006',
    },
    'lcd.fujitsu-a171' => {
        MANUFACTURER => 'Fujitsu Siemens Computers GmbH',
        MODEL        => 'A17-1',
        CAPTION      => 'A17-1',
        SERIAL       => 'YEEP525344',
        DESCRIPTION  => '34/2005'
    },
    'lcd.gericom-cy-96' => {
        MANUFACTURER => 'Plain Tree Systems Inc',
        MODEL        => 'CY965',
        CAPTION      => 'CY965',
        SERIAL       => 'F3AJ3A0019190',
        DESCRIPTION  => '41/2003',
    },
    'lcd.hp-nx-7000' => {
        MANUFACTURER => 'LGP',
        MODEL        => undef,
        CAPTION      => undef,
        SERIAL       => '00000000',
        DESCRIPTION  => '0/2003',
    },
    'lcd.hp-nx-7010' => {
        MANUFACTURER => 'LGP',
        MODEL        => undef,
        CAPTION      => undef,
        SERIAL       => '00000000',
        DESCRIPTION  => '0/2003',
    },
    'lcd.HP-Pavilion-ZV6000' => {
        MANUFACTURER => 'Quanta Display Inc.',
        MODEL        => 'JMN4A1P047325 QD15TL022',
        CAPTION      => 'JMN4A1P047325 QD15TL022',
        SERIAL       => '00000000',
        DESCRIPTION  => '51/2004',
    },
    'lcd.hp-l1950' => {
        MANUFACTURER => 'Hewlett Packard',
        MODEL        => 'HP L1950',
        CAPTION      => 'HP L1950',
        SERIAL       => 'CNK7420237',
        DESCRIPTION  => '42/2007'
    },
    'lcd.iiyama-pl2409hd' => {
        MANUFACTURER => 'Iiyama North America',
        MODEL        => 'PL2409HD',
        CAPTION      => 'PL2409HD',
        SERIAL       => '11004M0C00313',
        DESCRIPTION  => '49/2010'
    },
    'lcd.lg-l1960.1' => {
        MANUFACTURER => 'Goldstar Company Ltd',
        MODEL        => 'L1960TR ',
        CAPTION      => 'L1960TR ',
        SERIAL       => '9Y670',
        ALTSERIAL    => '00052aee',
        DESCRIPTION  => '11/2007'
    },
    'lcd.lg-l1960.2' => {
        MANUFACTURER => 'Goldstar Company Ltd',
        MODEL        => 'L1960TR ',
        CAPTION      => 'L1960TR ',
        SERIAL       => '9Y676',
        ALTSERIAL    => '00052af4',
        DESCRIPTION  => '11/2007'
    },
    'lcd.lg.tv.22MT44DP-PZ' => {
        MANUFACTURER => 'Goldstar Company Ltd',
        MODEL        => '2D FHD LG TV',
        CAPTION      => '2D FHD LG TV',
        SERIAL       => '01010101',
        DESCRIPTION  => '1/2013'
    },
    'lcd.lenovo-3000-v100' => {
        MANUFACTURER => 'AU Optronics',
        MODEL        => 'AUO B121EW03 V2',
        CAPTION      => 'AUO B121EW03 V2',
        SERIAL       => '00000000',
        DESCRIPTION  => '1/2006',
    },
    'lcd.lenovo-w500' => {
        MANUFACTURER => 'Lenovo Group Limited',
        MODEL        => 'LTN154U2-L05',
        CAPTION      => 'LTN154U2-L05',
        SERIAL       => '00000000',
        DESCRIPTION  => '0/2007',
    },
    'lcd.philips-150s' => {
        MANUFACTURER => 'Philips Consumer Electronics Company',
        MODEL        => 'PHILIPS  150S',
        CAPTION      => 'PHILIPS  150S',
        SERIAL       => ' HD  000237',
        DESCRIPTION  => '33/2001'
    },
    'lcd.philips-180b2' => {
        MANUFACTURER => 'Philips Consumer Electronics Company',
        MODEL        => 'Philips 180B2',
        CAPTION      => 'Philips 180B2',
        SERIAL       => ' HD  021838',
        DESCRIPTION  => '42/2002'
    },
    'lcd.philips-220v4' => {
        MANUFACTURER => 'Philips Consumer Electronics Company',
        MODEL        => 'Philips 220V4',
        CAPTION      => 'Philips 220V4',
        SERIAL       => 'UK4A1524032914',
        DESCRIPTION  => '24/2015'
    },
    'lcd.philips-243v5' => {
        MANUFACTURER => 'Philips Consumer Electronics Company',
        MODEL        => 'PHL 243V5',
        CAPTION      => 'PHL 243V5',
        SERIAL       => 'ZV0A1912014103',
        DESCRIPTION  => '12/2019'
    },
    'lcd.philips-288p6-vga' => {
        MANUFACTURER => 'Philips Consumer Electronics Company',
        MODEL        => 'Philips 288P6',
        CAPTION      => 'Philips 288P6',
        SERIAL       => 'AU5A1430006456',
        DESCRIPTION  => '30/2014'
    },
    'lcd.philips-288p6-hdmi' => {
        MANUFACTURER => 'Philips Consumer Electronics Company',
        MODEL        => 'Philips 288P6',
        CAPTION      => 'Philips 288P6',
        SERIAL       => '006456',
        ALTSERIAL    => '00001938',
        DESCRIPTION  => '30/2014'
    },
    'lcd.presario-R4000' => {
        MANUFACTURER => 'LG Philips',
        MODEL        => 'LGPhilipsLCD LP154W01-A5',
        CAPTION      => 'LGPhilipsLCD LP154W01-A5',
        SERIAL       => '00000000',
        DESCRIPTION  => '0/2004',
    },
    'lcd.rafael' => {
        MANUFACTURER => 'Rogen Tech Distribution Inc',
        MODEL        => 'B101715',
        CAPTION      => 'B101715',
        SERIAL       => '000005e5',
        DESCRIPTION  => '27/2004',
    },
    'lcd.regis' => {
        MANUFACTURER => 'Eizo Nanao Corporation',
        MODEL        => 'L557',
        CAPTION      => 'L557',
        SERIAL       => '82522083',
        DESCRIPTION  => '33/2003',
    },
    'lcd.samsung-191n' => {
        MANUFACTURER => 'Samsung Electric Company',
        MODEL        => 'SyncMaster',
        CAPTION      => 'SyncMaster',
        SERIAL       => 'GH19HCHW600639',
        ALTSERIAL    => 'HCHW600639',
        DESCRIPTION  => '23/2003'
    },
    'lcd.samsung-2494hm' => {
        MANUFACTURER => 'Samsung Electric Company',
        MODEL        => 'SyncMaster',
        CAPTION      => 'SyncMaster',
        SERIAL       => 'KI24H9XS933672',
        ALTSERIAL    => 'H9XS933672',
        DESCRIPTION  => '39/2009'
    },
    'lcd.samsung-s22c450' => {
        MANUFACTURER => 'Samsung Electric Company',
        MODEL        => 'S22C450',
        CAPTION      => 'S22C450',
        SERIAL       => '0276H4MF200047',
        ALTSERIAL    => 'H4MF200047',
        DESCRIPTION  => '6/2014'
    },
    'lcd.samsung-s24e450' => {
        MANUFACTURER => 'Samsung Electric Company',
        MODEL        => 'S24E450',
        CAPTION      => 'S24E450',
        SERIAL       => 'ZZHAH4ZKA00739',
        ALTSERIAL    => 'H4ZKA00739',
        DESCRIPTION  => '42/2018'
    },
    'lcd.tv.VQ32-1T' => {
        MANUFACTURER => 'Fujitsu Siemens Computers GmbH',
        MODEL        => 'VQ32-1T',
        CAPTION      => 'VQ32-1T',
        SERIAL       => '00000001',
        DESCRIPTION  => '40/2006',
    },
    'lcd.viewsonic-vx715' => {
        MANUFACTURER => 'ViewSonic Corporation',
        MODEL        => 'VX715',
        CAPTION      => 'VX715',
        SERIAL       => 'P21044404507',
        DESCRIPTION  => '44/2004'
    },
    'lcd.internal' => {
        MANUFACTURER => 'Toshiba Corporation',
        MODEL        => 'Internal LCD',
        CAPTION      => 'Internal LCD',
        SERIAL       => '00000004',
        DESCRIPTION  => '14/2006'
    },
    'IMP2262' => {
        MANUFACTURER => 'Impression Products Incorporated',
        MODEL        => '*22W1*',
        CAPTION      => '*22W1*',
        SERIAL       => '74701944',
        DESCRIPTION  => '47/2007'
    },
);

plan tests => (scalar keys %edid_tests) + 1;

foreach my $test (sort keys %edid_tests) {
    my $file = "resources/generic/edid/$test";
    my $edid = getAllLines(file => $file);
    my $info = FusionInventory::Agent::Task::Inventory::Generic::Screen::_getEdidInfo(edid => $edid, datadir => './share');
    cmp_deeply($info, $edid_tests{$test}, $test);
}
