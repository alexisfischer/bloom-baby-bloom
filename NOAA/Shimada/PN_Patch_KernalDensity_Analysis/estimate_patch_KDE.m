function [grid_lat, grid_data, density,lat_range_highest_data] = find_lat_patch(lat,data,bandwidth_lat,bandwidth_data,grid_size,top_percentage)
% use Kernel Density Estimation to find patches of PN and DA
%%% Inputs
% lat
% data
% grid_size = 50; % Adjust as needed
% bandwidth_lat = 0.6; % Adjust as needed
% bandwidth_data = 0.8; % Adjust as needed        
% top_percentage

% Create the grid for evaluation
grid_lat = linspace(min(lat), max(lat), grid_size);
grid_data = linspace(min(data), max(data), grid_size);

% Initialize the density matrix
density = zeros(grid_size, grid_size);

% Estimate the bivariate density using kernel smoothing, weight data
for i = 1:grid_size
    for j = 1:grid_size
        % Evaluate the density at each point on the grid
        x = [grid_lat(i), grid_data(j)];
        density(i, j) = mean(mvksdensity([lat, data], x,...
            'Bandwidth', [bandwidth_lat, bandwidth_data],...
            'Kernel', 'epanechnikov', 'Weights', data));
    end
end

% Flatten the density matrix and sort in descending order
density_flattened = density(:);
[sorted_density, sorted_indices] = sort(density_flattened, 'descend');

% Compute the cumulative sum of densities
cumulative_sum = cumsum(sorted_density);
total_sum = sum(sorted_density);

% Find the index corresponding to the top percentage threshold
threshold_index = find(cumulative_sum >= top_percentage * total_sum, 1, 'first');

% Extract the latitudinal range with the top percentage of density
selected_indices = sorted_indices(1:threshold_index);
selected_rows = mod(selected_indices, grid_size);
selected_rows(selected_rows == 0) = grid_size;
selected_cols = ceil(selected_indices / grid_size);
lat_range_highest_data = grid_lat(unique(selected_rows));

end