function [dist] = distance(u,v)
    radius = 6371.0;

    lat1 = deg2rad(u(1));
    lat2 = deg2rad(v(1));

    dLon = deg2rad(v(2) - u(2));

    dist = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(dLon)) * radius;
    
    dist = real(dist);
end
