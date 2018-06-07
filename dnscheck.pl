use LWP::Simple;
use Net::DNS;
use Socket;

open IN, "b.htaccess" or die "input open error $!";
@proxy_array = <IN>;
close IN;

open ADD, ">>b.htaccess.txt" or die "output open error $!";

foreach $temp(@proxy_array)
{
	@proxy_line = split/ /, $temp;

	# IP�A�h���X������ύX���ĉ�����
	$res = Net::DNS::Resolver->new;
	print "$proxy_line[2]";
	chomp $proxy_line[2];
	$query = $res->search($proxy_line[2], 'PTR');
	
	$name = "";
	
	#���s�����ꍇ
	if (!$query)
	{
		$name = $name. $res->errorstring;
		print ADD $temp;
	}
	else
	{
		#���ʂ�1�s�Â\��
		foreach $rr ($query->answer)
		{
			if ($rr->type eq "PTR")
			{
				$name = $name . $rr->ptrdname;
			}
		}
		chomp $temp;
		print ADD $temp . " # $name" . "\n";
	}
}
