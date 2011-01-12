res = 400

data = load('../test/cartman.npoff');
x = data(:,1:2);
x_normals = data(:,3:4);

corners = [min(x); max(x)];
center = mean(corners,1);
corners = (corners - repmat(center,[2 1])) * 1.2 + repmat(center,[2 1]);

start_sigma = 5;
goal_sigma = 5;

% plot_f(x, x_normals, ...
%        repmat(reshape(eye(2) * start_sigma^2, ...
%                       [1 2 2]), ...
%               [size(x,1) 1 1]), ...
%        corners, ...
%        'res', res)
% hold
% quiver(x(:,1),x(:,2),x_normals(:,1),x_normals(:,2),'color','black')
% 
% figure

[mu SIGMA] = EM(x, ...
                'a', 0.01, ...
                'initial_sigma', start_sigma, ...
                'target_sigma', goal_sigma, ...
                'centers_to_points_ratio', 1, ...
                'max_steps', 40);

mu_normals = ...
grad_weighted_signed_distance_fu(x, x_normals, ...
                                 repmat(reshape(eye(2) * start_sigma^2, ...
                                                [1 2 2]), ...
                                        [size(x,1) 1 1]), ...
                                 mu);
% normalize normals
mu_normals = mu_normals ./ repmat(sqrt(mu_normals(:,1).^2+mu_normals(:,2).^2), [1 2]);

plot_f(mu, mu_normals, squeeze(SIGMA), corners, 'res',res)
hold
quiver(mu(:,1),mu(:,2),mu_normals(:,1),mu_normals(:,2),'color','black')
scatter(x(:,1),x(:,2),'.r')