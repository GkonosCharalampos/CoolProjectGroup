clearvars;
global graph cars nodes paths millis travel_times over;

% Initialize mean and std vector
all_means = zeros(1, 100);
all_stds = zeros(1, 100);

time_str = get_time_str();

for num_cars = 50:50:5000
	initialize_simulation(num_cars);
	fprintf('num_cars: %d\n', num_cars);

	num_steps = 0;
	over = 0;
	while 1

	    if over
	       break;
	    end

	    advance_simulation();
	end

	fprintf('mean: %d\nstd: %d\n', mean(travel_times), int32(std(travel_times)));

	% update mean and std vector
	all_means(int32(num_cars / 50)) = mean(travel_times);
	all_stds(int32(num_cars / 50)) = std(travel_times);

	% write data to file after every iterations
	csvwrite(strcat(time_str, '_mean_travel_time.csv'), all_means);
	csvwrite(strcat(time_str, '_std_travel_time.csv'), all_stds);
end

