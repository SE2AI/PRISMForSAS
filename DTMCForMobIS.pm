dtmc
//configuration
const int CT=2; // 1 low band 2 high band
const int Login=2; // 1 SMS 2 internet
const int Locate=2; // 1 GPS 2 GSM
const int PT=1; // 1 online 2 offline
const int Form=2; // 1 Media 2 Text
const int Search=2;// 1 Voice 2 Text
const double T0=5; // value of time
const double B=5; // value of buffer
//failure probabilities of invariable transitions

const double t0=0.0005;
const double t1=0.0005;
const double t2=0.0002;
const double t3=0.0002;
const double t4=0.0003;
const double t5=0.0003;

const double t6=0.0003;
const double t7=0.0003;
const double t8=0.0003;
const double t9=0.0003;
const double t10=0.0003;
const double t11=0.0003;
const double t12=0.0003;
const double t13=0.0003;

const double t16=0.0005;
const double t18=0.002;
const double t19=1;
const double t20=0.0005;
const double t22=0.0002;

//failure probabilities of variable transitions
const double r11=0.005;
const double r12=0.0375;
const double r21=0.025;
const double r22=0.0125;

const double l11=0.0125;
const double l12=0.05;
const double l21=0.0375;
const double l22=0.005;

const double f11=0.02;
const double f12=0.0125;
const double f21=0.005;
const double f22=0.0025;

const double e1=0.01;
const double e2=0.005;


module  context
	c:[0..CT] init 0;
	[] c=0 -> (c'=CT);
	[ctfinish] c=CT -> true;
endmodule

module  login
	r:[0..Login] init 0;
	[ctfinish] r=0 -> (r'=Login);
	[Loginfinish] r=Login -> true;
endmodule

module  locate
	l:[0..Locate] init 0;
	[Loginfinish] l=0 -> (l'=Locate);
	[Locatefinish] l=Locate -> true;
endmodule

module  path
	p:[0..PT] init 0;
	[Locatefinish] p=0 -> (p'=PT);
	[ptfinish1] p=1 -> true;
	[ptfinish2] p=2 -> true;
endmodule

module  format
	f:[0..Form] init 0;
	[ptfinish1] f=0 -> (f'=Form);
	[start1] f=Form -> true;
endmodule

module  Searcharch
	e:[0..Search] init 0;
	[ptfinish2] e=0 -> (e'=Search);
	[start2] e=Search -> true;
endmodule

module mobis
	// local state
	s : [0..26] init 0;
	
	//[start1] s=0 -> 1-t0 : (s'=1) + t0 : (s'=23);
	[] s=0 -> 1-t0 : (s'=1) + t0 : (s'=23);
	[] s=1 -> 1-t1 : (s'=2) + t1 : (s'=23);
	[] s=2 -> 1-t2 : (s'=3) + t2 : (s'=23);
	[] s=3 -> 1-t3 : (s'=4) + t3 : (s'=23);
	[] s=4 -> 1-t4 : (s'=5) + t4 : (s'=23);
	[] s=5 & p=1 -> 1-t5 : (s'=6) + t5 : (s'=23);//onlineSearcht
	[] s=5 & p=2 -> 1-t5 : (s'=11) + t5 : (s'=23);//offlineSearcht
	[] s=23 -> true;
	
	[] s=6 -> 1-t6 : (s'=7) + t6 : (s'=24);
	[] s=7 -> 1-t7 : (s'=8) + t7 : (s'=24);
	[] s=8 -> 1-t8 : (s'=9) + t8 : (s'=24);
	[] s=9 -> 1-t9 : (s'=10) + t9 : (s'=24);
	[] s=10 -> 1-t10 : (s'=14) + t10 : (s'=24);
		
	[] s=11 -> 1-t11 : (s'=12) + t11 : (s'=24);
	[] s=12 -> 1-t12 : (s'=13) + t12 : (s'=24);
	[] s=13 -> 1-t13 : (s'=14) + t13 : (s'=24);
	[] s=24 -> true;
	
	[] s=16 & p=1 -> 1-t16 : (s'=17) + t16 : (s'=25);//onlineSearcht
	[] s=16 & p=2 -> 1-t16 : (s'=21) + t16 : (s'=25);//offlineSearcht
	[] s=20 -> 1-t20 : (s'=26) + t20 : (s'=25);
	[] s=22 -> 1-t22 : (s'=26) + t22 : (s'=25);
	[] s=25 -> true;
	[] s=26 -> true;
		
//alternative transitions
	[SMS] s=14 & r=1 & c=1 -> 1-r11 : (s'=15) + r11 : (s'=25);
	[SMS] s=14 & r=1 & c=2 -> 1-r12 : (s'=15) + r12 : (s'=25);
	[INT] s=14 & r=2 & c=1 -> 1-r21 : (s'=15) + r21 : (s'=25);
	[INT] s=14 & r=2 & c=2 -> 1-r22 : (s'=15) + r22 : (s'=25);

	[GPS] s=15 & l=1 & c=1 -> 1-l11 : (s'=16) + l11 : (s'=25);
	[GPS] s=15 & l=1 & c=2 -> 1-l12 : (s'=16) + l12 : (s'=25);
	[GSM] s=15 & l=2 & c=1 -> 1-l21 : (s'=16) + l21 : (s'=25);
	[GSM] s=15 & l=2 & c=2 -> 1-l22 : (s'=16) + l22 : (s'=25);

	[MED] s=17 & f=1 & c=1 -> 1-f11 : (s'=18) + f11 : (s'=25);
	[MED] s=17 & f=1 & c=2 -> 1-f12 : (s'=18) + f12 : (s'=25);
	[TXT] s=17 & f=2 & c=1 -> 1-f21 : (s'=18) + f21 : (s'=25);
	[TXT] s=17 & f=2 & c=2 -> 1-f22 : (s'=18) + f22 : (s'=25);

	[SearchND] s=18 -> 1-t18*T0 : (s'=19) + t18*T0 : (s'=25);
	[LOAD] s=19 -> 1-t19/B : (s'=20) + t19/B : (s'=25);
	
	[VOI] s=21 & e=1 -> 1-e1 : (s'=22) + e1 : (s'=25);
	[TXT] s=21 & e=2 -> 1-e2 : (s'=22) + e2 : (s'=25);

endmodule
module a1 = mobis [s=a1] endmodule
module a2 = mobis [s=a2] endmodule
module a3 = mobis [s=a3] endmodule
module a4 = mobis [s=a4] endmodule
module a5 = mobis [s=a5] endmodule


rewards "utility"
	
	[SMS] true : 5;
	[INT] true : 10;

	[GPS] true : 15;
	[GSM] true : 6;

	[MED] true : 20;
	[TXT] true : 9;

	[VOI] true : 15;
	[TXT] true : 3;

endrewards