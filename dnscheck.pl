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

	# IPアドレス部分を変更して下さい
	$res = Net::DNS::Resolver->new;
	print "$proxy_line[2]";
	chomp $proxy_line[2];
	$query = $res->search($proxy_line[2], 'PTR');
	
	$name = "";
	
	#失敗した場合
	if (!$query)
	{
		$name = $name. $res->errorstring;
		print ADD $temp;
	}
	else
	{
		#結果を1行づつ表示
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
