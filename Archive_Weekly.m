D=dir('/home/pcad/PCAD_Weekly')

% archives weekly directories that haven't been accessed in a month
% saves only the png plots, deletes the data and fig files to conserve
% space


for n=1:length(D)
    
    if datenum(now)-datenum(D(n).date)>30 & D(n).isdir & D(n).name(1)=='W'
            D(n).name
            cd(D(n).name)
            delete('*.mat')
            delete('*.dat')
            delete('*.fig')
            
            cd ..
            system(['mv ' D(n).name ' Archive']) 
        
    end
end