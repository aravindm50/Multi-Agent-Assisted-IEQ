
y =[
   195   240   330   340   330   280   280   250   200   204   185   155;
   250   360   450   460   450   436   404   350   330   315   260   205;
   293   430   530   543   554   555   485   411   395   397   325   250;
   280   385   500   523   540   527   470   400   362   375   305   257;
   235   301   375   403   425   407   375   345   285   310   240   195;
   237   265   317   310   353   355   323   275   265   248   187   165;
   217   325   320   358   375   422   425   340   248   236   209   185;
   333   400   490   450   475   530   520   435   400   380   309   236;
   365   500   609   530   560   633   580   550   515   491   409   307;
   370   545   655   555   635   668   590   700   640   566   390   302;
   396   545   655   677   730   750   790   801   605   455   372   280;
   408   552   650   757   756   825   900   855   652   500   315   270;
   325   549   543   755   690   770   822   795   597   535   301   232;
   360   470   430   717   740   770   770   747   585   505   280   207;
   272   358   473   648   758   745   660   572   443   377   242   177;
   170   320   388   615   580   501   420   430   347   293   212   160;
     0   388   370   528   528   425   375   356   335   286   235   200];
 figure
 a = jet(1000);
 c = colormap(a);
 h = surf(y);
 title('Lightmap of the room FEC2')
 
 caxis([150 1000])
 
 