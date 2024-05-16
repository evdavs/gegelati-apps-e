import os
import glob
import pandas as pd
import matplotlib.pyplot as plt

# List of directory paths where the CSV files are located
directory_paths = [
    '/home/edavies/Documents/gegelati-apps/pendulum/logs/2024-05-14_13-51-16',
    '/home/edavies/Documents/gegelati-apps/pendulum/logs/2024-05-14_14-23-42',
    '/home/edavies/Documents/gegelati-apps/pendulum/logs/2024-05-14_14-47-36',
    # Add more directory paths as needed
]

# Iterate over each directory path
for directory_path in directory_paths:
    print(f"Processing directory: {directory_path}")

    # Pattern to match CSV files
    csv_pattern = os.path.join(directory_path, '*.csv')

    # Get a list of all CSV file paths
    csv_files = glob.glob(csv_pattern)

    # List to store all DataFrame objects
    all_data = []

    # Iterate over each CSV file in the directory
    for csv_file in csv_files:
        print(f"Processing file: {csv_file}")
        # Read the CSV file into a DataFrame
        data = pd.read_csv(csv_file)

        # Append the DataFrame to the list
        all_data.append(data)

    # Concatenate all DataFrame objects into a single DataFrame
    combined_data = pd.concat(all_data)

    # Plot T_Max in function of Gen for the current directory
    plt.plot(combined_data['Gen'], combined_data['T_total'])
    plt.xlabel('Gen')
    plt.ylabel('T_total')
    plt.title(f'T_total vs. Gen - Directory: {os.path.basename(directory_path)}')
    plt.grid(True)
    plt.show()