function [out]=LTTquery(ltt,varargin)

% LTTquery: Queries the LTT database and returns a structure of ltt data 
%
%   Queries the ltt with the specified ltt file and times. 
%   Creates and output structure containing all of the data
%   from the .dat file that would be created running the ltt 
%   at the command line.and the ltt plot definitions.  Data 
%   structure is used as input to LTTplot.
% 
% EXAMPLE SYNTAX:  LTTquery('P_MUPS.ltt',time(2003200),time(2003275))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
%  LTTquery.m
% 
%  Date      Ver    Author      Change
%  10/10/03  000    S.Bucher    orig
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

del=1;
t=time;
for n=1:length(varargin)
    if isequal(class(varargin{n}),'time')
        t=[t varargin{n}];
    elseif strcmp('keep dat',varargin{n})
    del=0;        
    else error('Invalid input argument, must be time or string')
    end
end

query=which('LTTquery.pl');
t=sort(t);
tstart=t(1);
tstop=t(end);
settings=LTTsettings;
perl(query,settings.database,settings.server,settings.port,char(tstart,'greta'),char(tstop,'greta'),ltt)

ltt=strrep(ltt,'.ltt','.temp');
[msid,ptitle,units,opt]=textread(ltt,'%s%s%s%s','delimiter',',');
delete(ltt); %delete matlab freindly ltt file
out=struct('msid',msid,'ptitle',ptitle,'units',units,'opt',opt);
% put data into structure
for n=1:length(msid)
    
    fname=strcat(msid{n},'.txt');
    a=dlmread(fname);
    delete(fname);
    out(n).msid=strrep(out(n).msid,' ','');
    out(n).lttfile=strrep(ltt,'.temp','');
    out(n).data.day=time(a(:,1));
    out(n).data.min=a(:,2);
    out(n).data.mean=a(:,3);
    out(n).data.max=a(:,4);
    out(n).data.stdev=a(:,5);
    out(n).data.min_t=time(a(:,6));
    out(n).data.max_t=time(a(:,7));
    out(n).data.samples=a(:,8);
    
    
    [opt1,opt2]=strtok(out(n).opt);
end

save(out(1).msid,'out')
if del==0
    movefile('MatlabLTT.dat',[out(1).msid '.dat'])
else
delete('MatlabLTT.dat')
end