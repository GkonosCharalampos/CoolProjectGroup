function date_str = get_time_str()
%GET_TIME_STR Returns the current date and time as a string in the format 'YYYY-MM-DD_hh:mm:ss'
%     date_str = date string in the format 'YYYY-MM-DD_hh:mm:ss'
	date_str = sprintf('%04d-%02d-%02d_%02d:%02d:%02d', fix(clock));
end
