function [dist] = distance(u,v)
    radius = 6371.0;

    lat1 = (pi/180) * (u(1));
    lat2 = (pi/180) * (v(1));

    lon1 = (pi/180) * (u(2));
    lon2 = (pi/180) * (v(2));

	x = (lon2 - lon1) * cos((lat1 + lat2) / 2);
	y = (lat2 - lat1);
	dist = sqrt(x * x + y * y) * radius;
end
