#!/bin/csh -fxv 

foreach  case ( CAM5.ctrl )
#foreach member (  `seq -w 51 99`  )
#foreach member (  `seq -w 10 99`  )
#foreach member (  `seq -w 03 99`  )
#foreach member (  `seq -w 14 20`  )
#foreach member ( 42 )
foreach member ( 44 45 46 47 48 49 50 53 58 60 65 66 67 72 74 76 80 91 )
set nanhome = /glade/work/nanr/soil/ 
set casename = $case-$member 
set caseroot = $nanhome/dom21/{$casename}
set doTar = 0

if ($member == 01 ) set icyr = 2501
if ($member == 02 ) set icyr = 2511
if ($member == 03 ) set icyr = 2521
if ($member == 04 ) set icyr = 2531
if ($member == 05 ) set icyr = 2541
if ($member == 06 ) set icyr = 2551
if ($member == 07 ) set icyr = 2561
if ($member == 08 ) set icyr = 2571
if ($member == 09 ) set icyr = 2581
if ($member == 10 ) set icyr = 2591

if ($member == 11 ) set icyr = 2506
if ($member == 12 ) set icyr = 2516
if ($member == 13 ) set icyr = 2526
if ($member == 14 ) set icyr = 2536
if ($member == 15 ) set icyr = 2546
if ($member == 16 ) set icyr = 2556
if ($member == 17 ) set icyr = 2566
if ($member == 18 ) set icyr = 2576
if ($member == 19 ) set icyr = 2586
if ($member == 20 ) set icyr = 2596
 
if ($member == 21 ) set icyr = 2401
if ($member == 22 ) set icyr = 2411
if ($member == 23 ) set icyr = 2421
if ($member == 24 ) set icyr = 2431
if ($member == 25 ) set icyr = 2441
if ($member == 26 ) set icyr = 2451
if ($member == 27 ) set icyr = 2461
if ($member == 28 ) set icyr = 2471
if ($member == 29 ) set icyr = 2481
if ($member == 30 ) set icyr = 2491

if ($member == 31 ) set icyr = 2406
if ($member == 32 ) set icyr = 2416
if ($member == 33 ) set icyr = 2426
if ($member == 34 ) set icyr = 2436
if ($member == 35 ) set icyr = 2446
if ($member == 36 ) set icyr = 2456
if ($member == 37 ) set icyr = 2466
if ($member == 38 ) set icyr = 2476
if ($member == 39 ) set icyr = 2486
if ($member == 40 ) set icyr = 2496

if ($member == 41 ) set icyr = 2101
if ($member == 42 ) set icyr = 2111
if ($member == 43 ) set icyr = 2121
if ($member == 44 ) set icyr = 2131
if ($member == 45 ) set icyr = 2141
if ($member == 46 ) set icyr = 2151
if ($member == 47 ) set icyr = 2161
if ($member == 48 ) set icyr = 2171
if ($member == 49 ) set icyr = 2181
if ($member == 50 ) set icyr = 2191

if ($member == 51 ) set icyr = 2106
if ($member == 52 ) set icyr = 2116
if ($member == 53 ) set icyr = 2126
if ($member == 54 ) set icyr = 2136
if ($member == 55 ) set icyr = 2146
if ($member == 56 ) set icyr = 2156
if ($member == 57 ) set icyr = 2166
if ($member == 58 ) set icyr = 2176
if ($member == 59 ) set icyr = 2186
if ($member == 60 ) set icyr = 2196

if ($member == 61 ) set icyr = 2201
if ($member == 62 ) set icyr = 2211
if ($member == 63 ) set icyr = 2221
if ($member == 64 ) set icyr = 2231
if ($member == 65 ) set icyr = 2241
if ($member == 66 ) set icyr = 2251
if ($member == 67 ) set icyr = 2261
if ($member == 68 ) set icyr = 2271
if ($member == 69 ) set icyr = 2281
if ($member == 70 ) set icyr = 2291

if ($member == 71 ) set icyr = 2206
if ($member == 72 ) set icyr = 2216
if ($member == 73 ) set icyr = 2226
if ($member == 74 ) set icyr = 2236
if ($member == 75 ) set icyr = 2246
if ($member == 76 ) set icyr = 2256
if ($member == 77 ) set icyr = 2266
if ($member == 78 ) set icyr = 2276
if ($member == 79 ) set icyr = 2286
if ($member == 80 ) set icyr = 2296

if ($member == 81 ) set icyr = 2301
if ($member == 82 ) set icyr = 2311
if ($member == 83 ) set icyr = 2321
if ($member == 84 ) set icyr = 2331
if ($member == 85 ) set icyr = 2341
if ($member == 86 ) set icyr = 2351
if ($member == 87 ) set icyr = 2361
if ($member == 88 ) set icyr = 2371
if ($member == 89 ) set icyr = 2381
if ($member == 90 ) set icyr = 2391

if ($member == 91 ) set icyr = 2306
if ($member == 92 ) set icyr = 2316
if ($member == 93 ) set icyr = 2326
if ($member == 94 ) set icyr = 2336
if ($member == 95 ) set icyr = 2346
if ($member == 96 ) set icyr = 2356
if ($member == 97 ) set icyr = 2366
if ($member == 98 ) set icyr = 2376
if ($member == 99 ) set icyr = 2386
if ($member == 100 ) set icyr = 2396

if ($doTar == 1) then
cd  /glade/scratch/nanr/$casename/run
cp /glade/scratch/nanr/hpss/haiyan/f.e11.F1850C5CN.f09_f09.001/rest/${icyr}-01-01-00000.tar .
tar -xvf *.tar
rm ${icyr}-01-01-00000.tar
endif

cd $caseroot
qsub -A P93300313 $casename.run 
end 
end 
exit

