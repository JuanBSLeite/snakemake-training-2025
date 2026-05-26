import uproot as up
import matplotlib.pyplot as plt
import numpy as np

import sys

def plot_histogram(input_file, output_file):
    # Open the ROOT file and access the tree
    with up.open(input_file) as file:
        tree = file["genResults"]  # Replace "tree" with the actual name of your tree

        # Extract the data for the histogram (replace "variable" with the actual variable name)
        m13Sq = tree["m13Sq"].array(library="np")  # Replace "variable" with the actual variable name
        m23Sq = tree["m23Sq"].array(library="np")  # Replace "variable" with the actual variable name

        H , x_edges, y_edges = np.histogram2d(m13Sq, m23Sq, bins=(50, 50))  # Adjust bins as needed

        H = H.T

        # Plot the histogram
        plt.figure(figsize=(10, 6))
        plt.imshow(H, origin='lower', interpolation='nearest', aspect='auto', extent=[x_edges[0], x_edges[-1], y_edges[0], y_edges[-1]])
        plt.xlabel("m13Sq")  # Replace with actual variable name
        plt.ylabel("m23Sq")  # Replace with actual variable name
        plt.title("Dalitz Plot")  # Replace with actual variable name
        plt.colorbar(label="Frequency")
        plt.grid(True)

        # Save the plot to a file
        plt.savefig(output_file)
        plt.close()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python plotHistogram.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    plot_histogram(input_file, output_file)