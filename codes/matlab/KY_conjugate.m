% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function solves the Kalman-Yakubovich equation X = BXM'+C for the matrix X. It is only
% used as a short-hand to calculate the IRFs of the higher order beliefs in Figure A7.

function X = KY_conjugate(B, M, C)
    % Get the size of the matrix
    n = size(B, 1);

    % Create the identity matrix of size n^2
    I = eye(n^2);

    % Compute the Kronecker product
    A = I - kron(M, B);

    % Reshape C into a column vector
    b = C(:);

    % Solve the linear system
    x = A \ b;

    % Reshape the solution back into a matrix
    X = reshape(x, n, n);
end