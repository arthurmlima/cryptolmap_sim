function H = myentropy(X)
% Establish size of data
[n m] = size(X);

% Housekeeping
H = zeros(1,m);
for Column = 1:m
    % Assemble observed alphabet
    Alphabet = unique(X(:,Column));

    % Housekeeping
    Frequency = zeros(size(Alphabet));

    % Calculate sample frequencies
    for symbol = 1:length(Alphabet)
        Frequency(symbol) = sum(X(:,Column) == Alphabet(symbol));
    end

    % Calculate sample class probabilities
    P = Frequency / sum(Frequency);

    % Calculate entropy in bits
    H(Column) = -sum(P.*log2(P));
end