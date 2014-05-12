function [dist] = distance(u,v)
    radius = 6371.0;

    lat1 = (pi/180) * (u(1));
    lat2 = (pi/180) * (v(1));

    dLon = (pi/180) * (v(2) - u(2));

    dist = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(dLon)) * radius;

    dist = real(dist);
end
