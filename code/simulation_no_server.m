clearvars;
global graph cars nodes paths millis travel_times over;

all_means = zeros(1, 100);
all_stds = zeros(1, 100);

% tottime = 0;
for num_cars = 50:50:5000
	initialize_simulation(num_cars);
	fprintf('num_cards: %d\n', num_cars);

	num_steps = 0;
	over = 0;
	while 1

	    if over
	       break;
	    end

	    advance_simulation();

	    num_steps = num_steps + 1;
	    % if mod(num_steps, 5) == 0
	    %     fprintf('number of iterations: %d\n', num_steps);
	    % end
	    % 'advance simulation'
	end

	fprintf('mean: %d\nstd: %d\n', mean(travel_times), int32(std(travel_times)));

	all_means(int32(num_cars / 50)) = mean(travel_times);
	all_stds(int32(num_cars / 50)) = std(travel_times);
end

time_str = get_time_str();
csvwrite(strcat(time_str, '_mean_travel_time.csv'), all_means);
csvwrite(strcat(time_str, '_std_travel_time.csv'), all_stds);
