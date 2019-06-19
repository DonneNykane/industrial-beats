# Final state of the project

### How does the final result relate to the initial idea?

The initial idea was to create a sort of "beat generator" based on a performance found on a YouTube video (link in notes.md).
Although it doesn't quite match the original intended sound, aesthetic similarities are present in the final sound, especially
when parameters are set in a certain way, however it lacks a certain "heaviness" that is present in the original performance.


### Are there any areas that fell short?

It is very unfortunate that the final version is unable to change Modulation Algorithms in real time (i.e. mid performance).
An attempted implementation involved a case statement within a single synth defintion containing all the algorithms, however
it was later discovered that the reason this didn't work was due to the SC Server not working with boolean logic in the same
way the SC Client does. It transpires that a similar outcome can be achieved by using a control signal to only allow certain
audio signals through a mixer at different times, however attempts to implement this resulted in failure.

### How can it be improved?

Other than solving the problem described above, a huge improvement would be to map key parameters such as release time, mod
amount, feedback, release time etc to a midi controller.
