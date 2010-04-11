#===============================================================================
#
#  DESCRIPTION:  test include block
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================
#$Id$
package T::Include;
use strict;
use warnings;
use Test::More;
use Data::Dumper;
use base 'TBase';

sub p01_test_include_from_pod_with_patterns : Test {
    my $t = shift;
    my $x = $t->parse_to_xml( <<T, );
=begin pod
=include t/data/P_test1.pod(para :aa)
=end pod
T
    $t->is_deeply_xml(
        $x,
q#<pod pod:type='block' xmlns:pod='http://perlcabal.org/syn/S26.html'><include pod:type='block'><para pod:type='block' aa='1'>para1
</para></include></pod>#
    );
}

sub p02_test_xhtml : Test {
    my $t = shift;
    my $x = $t->parse_to_xhtml( <<T, );
=begin pod
=include t/data/P_test1.pod(para :aa)
=end pod
T
    $t->is_deeply_xml(
        $x,
        q#<xhtml xmlns='http://www.w3.org/1999/xhtml'><p>para1
</p></xhtml>#
    );
}

sub p03_test_docbook : Test {
    my $t = shift;
    my $x = $t->parse_to_docbook( <<T, );
=begin pod
=include t/data/P_test1.pod(para :aa)
=end pod
T
    $t->is_deeply_xml(
        $x,
        q#<chapter><para aa='1'>para1
</para></chapter>#
    );
}

sub p04_test_2_exp : Test {
    my $t = shift;
    my $x = $t->parse_to_xml( <<T, );
=begin pod
=include t/data/P_test1.pod(para :aa, para :private)
=end pod
T
    $t->is_deeply_xml(
        $x,
q#<pod pod:type='block' xmlns:pod='http://perlcabal.org/syn/S26.html'><include pod:type='block'><para pod:type='block' aa='1'>para1
</para><para pod:type='block' private='1'>This is a secure hole !
</para></include></pod>#
    );
}

sub p05_test_attr_only : Test {
    my $t = shift;
    my $x = $t->parse_to_xml( <<T, );
=begin pod
=include t/data/P_test1.pod(:private)
=end pod
T
    $t->is_deeply_xml(
        $x,
q#<pod pod:type='block' xmlns:pod='http://perlcabal.org/syn/S26.html'><include pod:type='block'><head1 pod:type='block' private='1'>Test1 This is content
</head1><para pod:type='block' private='1'>This is a secure hole !
</para></include></pod>#
      )

}

1;

