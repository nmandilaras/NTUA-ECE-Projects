import numpy as np

class NeuralNetwork(object):
    def __init__(self, input_nodes, hidden_nodes, output_nodes, learning_rate,iterations):
        # Set number of nodes in input, hidden and output layers.
        self.input_nodes = input_nodes
        self.hidden_nodes = hidden_nodes
        self.output_nodes = output_nodes
        self.iterations = iterations

        # Initialize weights
        self.weights_input_to_hidden = np.random.normal(0.0, self.input_nodes**-0.5,
                                       (self.input_nodes, self.hidden_nodes))

        self.weights_hidden_to_output = np.random.normal(0.0, self.hidden_nodes**-0.5,
                                       (self.hidden_nodes, self.output_nodes))
        self.lr = learning_rate

        self.activation_function = lambda x : 1 / (1 + np.exp(-x))  # Replace 0 with your sigmoid calculation.

    def train(self, features, targets):

        n_records = features.shape[0]
        for i in range(self.iterations):
            delta_weights_i_h = np.zeros(self.weights_input_to_hidden.shape)
            delta_weights_h_o = np.zeros(self.weights_hidden_to_output.shape)
            for X, y in zip(features, targets): # X,y take values from features and targets arrays correspondingly
                #### Implement the forward pass here ####
                ### Forward pass ###
                hidden_inputs = np.dot(X,self.weights_input_to_hidden)
                hidden_outputs = self.activation_function(hidden_inputs)

                final_outputs = np.dot(hidden_outputs,self.weights_hidden_to_output)

                #### Implement the backward pass here ####
                ### Backward pass ###
                error = y - final_outputs

                hidden_error = np.dot(error,self.weights_hidden_to_output.T)

                output_error_term = error
                # Output layer error is the difference between desired target and actual output.
                # Find the error of output layer
                ###TODO###

                #this
                delta_error = hidden_outputs * (1 - hidden_outputs) # calculate the delta of the error
                hidden_error_term = hidden_error * delta_error

                # Weight step (input to hidden)
                delta_weights_i_h += hidden_error_term * X[:, None]
                # Weight step (hidden to output)
                delta_weights_h_o += output_error_term * hidden_outputs[:, None]

            self.weights_hidden_to_output += self.lr * delta_weights_h_o / n_records # update hidden-to-output weights with gradient descent step
            self.weights_input_to_hidden += self.lr * delta_weights_i_h / n_records # update input-to-hidden weights with gradient descent step

    def run(self, features):

        #### Implement the forward pass here ####
        hidden_inputs = np.dot(features, self.weights_input_to_hidden) # signals into hidden layer
        hidden_outputs = self.activation_function(hidden_inputs) # signals from hidden layer

        final_inputs = np.dot(hidden_outputs, self.weights_hidden_to_output) # signals into final output layer
        ###final_outputs = final_inputs # signals from final output layer

        return final_inputs