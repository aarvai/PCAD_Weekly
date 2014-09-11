%function PCAD_Weekly

% runs PCAD Weekly plot generation, data collection and archives old directoies
%
% SYNTAX:  PCAD_Weekly(yyyyddd,YYYYDDD) where yyyyddd=startday, YYYYDDD=end day
%
%           generally run for 45 days to provide context in plots 


% get dates for weekly from eng directory, if no directory for this week
% make one


d=dir('/share/FOT/engineering/reports/weekly/2014');
if time(clock)-time(str2num(d(end).name(end-6:end)))>7*86400
%if 1==2     
    first=time(str2num(d(end).name(end-6:end)))+86400;
    last = first+6*86400;
    first_str=strrep(char(first),':','');
    last_str=strrep(char(last),':','');
    % creates in pcad account unless you cd into reports before creating
    % directory
    cd /share/FOT/engineering/reports/weekly/2014/
    mkdir([first_str(1:7) '_' last_str(1:7) ]);
    cd '/home/pcad/PCAD_Weekly'
    d=dir('/share/FOT/engineering/reports/weekly/2014');
else
    last=time(str2num(d(end).name(end-6:end)));
%    last=time(2013116)
    first = last-6*86400
    first_str=strrep(char(first),':','');
    last_str=strrep(char(last),':','');
end

% set up to run LTT
tstart=last-45*86400
tstop=last
addpath('/home/pcad/PCAD_Weekly')
sd=strrep(char(tstart),':','');
ed=strrep(char(tstop),':','');
sd=str2num(sd(1:7));
ed=str2num(ed(1:7));
ltt_root='/home/pcad/AXAFUSER/ltt/';

% set up output directory
cd /home/pcad/PCAD_Weekly;
dn=['Weekly_' num2str(sd) '_' num2str(ed)];
mkdir(dn);
cd(dn);
fid=fopen('PCAD_Weekly_Summary.txt','w+');


%run LTT
temp=LTTquery([ltt_root 'A_1SHOT.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,2)
close all
clear temp

temp=LTTquery([ltt_root 'A_ATTITUDE.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,4)
% put solar array range in summary
fprintf(fid,'%s\n\n',['Solar Array Range for '  first_str(1:7) ' to ' last_str(1:7) ':']);
fprintf(fid,'%s%3.0f\n','Solar Array Min:  ',min(temp(1).data.min(end-7:end)));
fprintf(fid,'%s%3.0f\n\n','Solar Array Max:  ',max(temp(1).data.max(end-7:end)));
close all
clear temp

temp=LTTquery([ltt_root 'A_A_CONV_VOLTAGE.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,4)
close all
clear temp


temp=LTTquery([ltt_root 'A_GYRO_BIAS.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,3)
% put bias range in summary for reference
fprintf(fid,'%s\n\n',['Bias Ranges for '  first_str(1:7) ' to ' last_str(1:7) ':']);
fprintf(fid,'%s%4.3f\n','Roll Bias Min:   ',min(temp(1).data.min(end-7:end)));
fprintf(fid,'%s%4.3f\n','Roll Bias Max:   ',max(temp(1).data.max(end-7:end)));
fprintf(fid,'%s%4.3f\n','Pitch Bias Min:  ',min(temp(2).data.min(end-7:end)));
fprintf(fid,'%s%4.3f\n','Pitch Bias Max:  ',max(temp(2).data.max(end-7:end)));
fprintf(fid,'%s%4.3f\n','Yaw Bias Min:    ',min(temp(3).data.min(end-7:end)));
fprintf(fid,'%s%4.3f\n\n','Yaw Bias Max:    ',max(temp(3).data.max(end-7:end)));
close all
clear temp


temp=LTTquery([ltt_root 'A_HW_ERR.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,2)
close all
clear temp


temp=LTTquery([ltt_root 'A_IRU_2.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,2)
close all
clear temp

temp=LTTquery([ltt_root 'A_PNT_CTRL_STAB.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,2)
close all
clear temp

temp=LTTquery([ltt_root 'A_RW_CURRENT_TEMP.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,6)
close all
clear temp

temp=LTTquery([ltt_root 'A_RW_SPEED.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,6)
close all
clear temp

temp=LTTquery([ltt_root 'A_SYSMOM.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,3)
close all
clear temp

temp=LTTquery([ltt_root 'A_WDE_CONV_VOLTAGE.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,6)
close all
clear temp


% get this week's drag torque data
UpdateDragTorqueData(tstop)

% update oneshot data
cd /home/pcad/matlab/1_SHOT
addpath(pwd)
% find end of existing data and start at the beginning of that day (overlap is OK)
man=BuildManStruc('ManeuverData');
format long g
mt=str2num(char(man(end).StartTime,'greta'));


% run One Shots
if mt<ed
    clear man   
    cd ManeuverData
    OneShots(floor(mt),ed);
    cd ..
    man=BuildManStruc('ManeuverData');
end

cd plots
plotOneShots(man)
oned=dir('/home/pcad/matlab/1_SHOT/plots');
system(['cp ' oned(end).name ' /share/FOT/engineering/pcad/One_Shot_Updates/OneShotPlot_SinceSwap.png']);
% find this week's max one shot
man=man(find([man.StartTime]>first & [man.EndTime]<last));
[m,i]=max([man.magUp]);
fprintf(fid,'%s\n\n','Maximum One Shot:');
fprintf(fid,'%3.2f%s%3.0f%s\n',man(i).magUp,[' arcsec at ' char(man(i).UpTime) ' after a '],man(i).ManAng,' degree maneuver');
fclose(fid);

% update web data
cd /home/pcad/PCAD_Weekly;
cd(dn)
display('Copying to /share/FOT/engineering/pcad/WeeklyPlots')
system('cp *.png /share/FOT/engineering/pcad/WeeklyPlots');
display(['Copying to ' d(end).name])
system(['cp GCA_BIAS1_1.png /share/FOT/engineering/reports/weekly/2014/' d(end).name]);
system(['cp AIRU2G1I_1.png /share/FOT/engineering/reports/weekly/2014/' d(end).name]);
system(['cp PCAD_Weekly_Summary.txt /share/FOT/engineering/reports/weekly/2014/' d(end).name]);
% archive directories that haven't been used in 30 days
cd ..
Archive_Weekly

%Run Prop Weekly
cd /home/pcad/PROP_Weekly
tstart=last-7*86400
sd=strrep(char(tstart),':','');
sd=str2num(sd(1:7));
PROP_Weekly(sd,ed)
