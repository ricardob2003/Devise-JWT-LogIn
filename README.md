



# Custom Sessions Controller for Diverse Login Scenarios

This repository showcases a custom Sessions Controller designed to handle various types of login scenarios, accommodating both traditional web applications (monolithic) and API services. The implementation leverages techniques adapted from this detailed guide on setting up Rails 7 with Devise and JWT for authentication, which provides a robust foundation for secure user authentication using JSON Web Tokens (JWTs).
### Key Features and Implementation:

- Dual Support for Monolithic and API Applications: The custom Sessions Controller is adept at managing authentication across different architectures. For monolithic applications, it ensures seamless session management with traditional sign-in and sign-out flows. For API-centric applications, it leverages JWTs to handle stateless, secure authentication, which is essential for mobile apps and other frontend technologies that consume the API.

- Role-Based Access Control: By integrating a column in the User table to specify if a user is an admin, the application can tailor the login process and session management accordingly. This role-based approach allows for finer control over user capabilities and access within the app.

- Adaptation of Best Practices from the Guide: The guide by SDRMike on Rails 7 API-only apps was instrumental in structuring our JWT implementation and securing the API endpoints. It provides a step-by-step approach to setting up Devise with JWT in a Rails environment, ensuring that our application adheres to modern security practices while maintaining flexibility in user management.