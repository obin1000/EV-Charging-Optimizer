function [hours,minutes] = minutes_to_time(minutes)
%MINUTES_TO_TIME Converts a total sum of minutes to a normal clock format
hours = floor(minutes / 60);
minutes = mod(minutes, 60);
end

