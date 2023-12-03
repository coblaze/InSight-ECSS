# InSight-ECSS
InSight-ECSS is a project dedicated to developing an app to aid blind users in navigating a section of our engineering building using Xcode. The project focuses on creating a graph where the nodes and edges represent rooms and hallways respectively. The graph then uses A* or Dijkstra's algorithm to generate the shortest path. 

### Why aren't we using the university's mapping API?
Ideally, we would leverage the university's mapping API, facilitated by Concept3D, a third-party mapping service. However, the use of the Concept3D API is contingent on a paid subscription. So, we've opted to take an alternative approach.

Instead of utilizing the Concept3D API, we're creating our own graph based on the static map provided by the university. This involves applying algorithms to the map, allowing our users, particularly visually impaired students, to navigate the ECSS building efficiently.

While this process may seem labor-intensive, choosing this method serves a dual purpose. Firstly, it's FREE! Secondly, and perhaps more importantly, it provides an invaluable learning opportunity for students involved in this project. By implementing algorithms in a real-world context, participants gain practical insights into addressing complex scenarios.

## Motivation
The motivation behind this project is to provide a solution that assists blind users in navigating through our engineering building independently and safely. The app aims to overcome the constraints of not having access to a third-party API with interior mapping of the school or Bluetooth beacons set up around the ECSS department.

## Use Case
InSight caters specifically to visually impaired individuals studying or working in the ECSS department. Users can vocalize their destination, and the application will provide step-by-step directions, enabling them to navigate the building with confidence. The absence of third-party APIs or Bluetooth beacons doesn't hinder the effectiveness of the solution, as it relies on the building's inherent structure.

## Key Features

- **Graph Representation**: Nodes represent rooms, and edges represent hallways, creating a comprehensive graph of the ECSS department.
- **A\* or Dijkstra's Algorithm:** Utilizing these pathfinding algorithms to determine the most efficient route between two points within the building.
- **YOLOv3**: Utilizing this machine-learning model to detect objects in real-time which will be instrumental in identifying obstacles and ensuring safe navigation. 
- **Xcode Integration**: The project files in this repository are designed for use with Xcode, making it accessible for developers familiar with iOS development.

## Future Considerations

While InSight currently focuses on the ECSS department, future considerations include expanding the mapping system to cover additional rooms and hallways within the ECSS building. The long-term vision involves extending this solution to other engineering buildings on campus, creating a comprehensive and accessible navigation tool for visually impaired individuals throughout the entire engineering campus.

## How to Contribute

We welcome contributions from developers, designers, and anyone passionate about improving accessibility. Feel free to fork the repository, make enhancements, and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License
- YOLOv3: Licensed under the [Apache License 2.0](https://github.com/AlexeyAB/darknet/blob/master/LICENSE)
- Apple's Location Services: Usage of these services is subject to the terms and conditions of the [Apple Developer Program License Agreement](https://developer.apple.com/terms/).

In addition to these, our code is distributed under the MIT license. 

- [MIT](https://choosealicense.com/licenses/mit/)

[InSight](https://coblaze.github.io/InSightWB/)
