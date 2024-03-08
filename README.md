# TVMazeApp
Application for listing TV series, using the API provided by the TVMaze website.

## Running the app
 - Preferably use Xcode 15.3
 - Go to the project target under 'Signing & Capabilities' and change the team to 'none'

<img width="500" alt="Screenshot 2024-03-08 at 19 07 17" src="https://github.com/felipembassi/TVMazeApp/assets/4182255/8cff7321-543d-4276-aad0-a7a0549e2399">

## Architecture Overview

### MVVM (Model-View-ViewModel)

- **Model**: Defines the data structure. In TVMazeApp, models represent TV shows, episodes, and other relevant data fetched from the TVMaze API.
- **View**: Responsible for the user interface. Views are SwiftUI views that present data to the user and capture user interactions.
- **ViewModel**: Acts as a bridge between the Model and View. It handles business logic, data transformation, and state management, exposing data in a form easily consumable by the View.

### Coordinator Pattern

The app uses the Coordinator pattern to manage navigation and the flow between different screens. This approach decouples navigation logic from the views and view models, enhancing the separation of concerns and making the navigation more manageable.

### Dependency Injection

Dependency injection is used to provide view models and other components with the services and dependencies they require. This facilitates testing and allows for greater flexibility in swapping out implementations.

### Combine

Combine is utilized for reactive programming, allowing the app to respond to changes in data and user inputs in a declarative way. It simplifies state management and interaction between the app's components.

## Features

- List TV shows with options to search.
- View detailed information about TV shows and episodes.
- Allow the user to save a series as a favorite.
- People list and search by listing the name and image of the person.
- Person detail screen
- Allow the user to set a PIN number to secure the application and prevent unauthorized users.
- For supported phones, the user must be able to choose if they want to enable fingerprint authentication to avoid typing the PIN number while opening the app.


## Suggestions for Improvement

### Decoupling Services

- **Abstract Service Interfaces**: Further decouple the app by defining abstract interfaces for each service.

### Modularization

- **Feature Modules**: Consider modularizing the app into feature-specific modules (e.g., Shows, Episodes, Favorites).
- **Components**
- **Design System**
- **Network**
- **etc**

### State

- **Enhanced State Handling**: Adopt enums to manage the state of data, encapsulating loading, success, and error states. This would simplify state tracking and reduces the need for separate variables.


