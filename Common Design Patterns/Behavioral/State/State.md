# State Design Pattern
`State` is a behavioral design pattern that allows an object to change its behavior when its internal state changes. Conceptually, the pattern reminds a finite-state machine, except it does not support `transitioning` between the states. The pattern is similar to another behavioral design pattern called [Strategy](/Common%20Design%20Patterns/Behavioral/Strategy/Strategy.md). Despite their similarities they have different applications and purposes: `Strategy` pattern is meant to be used in conjunction with algorithms, where `State` design pattern may define internal rules when changing states. Also, states are driven by the methods defined inside the `StateProtocol`. 

The pattern, as it was pointed out, is run-time driven so to speak. That means the states can be swapped, added, changed or replaced at run-time. Another problem that the pattern solves is it can flatten out a number of if-else statements into a linear structure. 

## Music Player
In order to dive into the pattern we will implement a music player with a number of states: 

```swift
- Prepare: here our song should be loaded and prepared
- Play: plays a song or resumes the playback if the previous state was `Stop` state
- Stop: stops the playback or pauses it
```

The pattern consists of two main pieces of architecture: `StateProtocol` and `Context`. `StateProtocol` defines a number of methods each of which should be implemented is a separate type and incapsulate the state-specific logic. `Context` holds a property that changes its type depending on a concrete `State`. 

```swift
protocol PlayerState {
    func prepare()
    func play()
    func stop()
}
```

Here we defined a `PlayerState` protocol with a number of methods for each of the states. Next, we need to provide the default implementation in order to eliminate the need for each of the state types to provide implementations for each of the states. 

```swift
extension PlayerState {
    func prepare()  { /* empty implementation */ }
    func play()     { /* empty implementation */ }
    func stop()     { /* empty implementation */ }
}
``` 

We could use optional methods by using the `Objective-C`'s runtime, but let’s remain our code Swifty. 

Next step is to implement the concrete states for each of the methods. But before doing that we need to declare another protocol called `Playable`. This protocol is needed for each of the states to be able to accept a reference to the audio player and be able to trigger a state-specific action. Or it simply adds support for property & initializer [Dependency Injection](/Common%20Design%20Patterns/Creational/DependencyInjection/DependencyInjection.md).

```swift
protocol Playable {
    var player: AVAudioPlayer { get set }
}
```
We are going to use `AVFoundation` as a base framework for audio playback. We declared a separate protocol for the `player` property in order to conform to the `Interface Segregation Principle` and leave a room for possible, future states to be free from potential, unneeded properties. 

```swift
struct PrepareState: PlayerState, Playable {
    
    // MARK: - Conformance to Playable protocol
    
    var player: AVAudioPlayer
    
    // MARK: - Conformance to PlayerState protocol
    
    func prepare() {
        player.prepareToPlay()
    }
}

struct PlayState: PlayerState, Playable {
    
    // MARK: - Conformance to Playable protocol
    
    var player: AVAudioPlayer
    
    // MARK: - Conformance to PlayerState protocol
    
    func play() {
        player.play()
    }
}

struct StopState: PlayerState, Playable {
    
    // MARK: - Conformance to Playable protocol
    
    var player: AVAudioPlayer
    
    // MARK: - Conformance to PlayerState protocol
    
    func stop() {
        player.stop()
    }
}
```

The presented states are quite trivial: we simply wrapped a state-specific action into a separate type that conforms to both `PlayerState` and `Player` protocols. 

## Context
As it was mentioned before, `Context` is an essential piece of the pattern’s architecture. It will hold a state property that will be dynamically changed depending on a concrete state. 

Let's define one for our music player:

```swift
class PlayerContext {
    
    // MARK: - Properties
    
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer.init()
    private(set) var state: PlayerState
    
    var song: Song {
        didSet {
            preparePlayer()
            stop()
            state.prepare()
        }
    }
```

The `audioPlayer` property defines a domain-specific audio player that will be shared among the states and perform actions. 

The `state` property defines a concrete state of our `PlayerContext` class. The initial state is always going to be `prepare`. 

The final property is `song`. `Song` is a simple class that consists of two properties for song's name and file url. 

Next, we implement the designated initializer:

```swift
	// MARK: - Initializers
    
    init(song: Song) {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
        
        state = PrepareState(player: audioPlayer)
        self.song = song
        preparePlayer()
    }
```

The initializer prepares the `AVFoundation` framework-specific setup and sets the state to the `PrepareState`. 

The final part of the `Context` is actual methods that change the state of the player and delegate the actual actions:

```swift
 	// MARK: - Methods
    
    func play() {
        guard state is StopState || state is PrepareState else { return }
        state = PlayState(player: audioPlayer)
        state.play()
    }
    
    func stop() {
        guard state is PlayState  else { return }
        state = StopState(player: audioPlayer)
        state.stop()
    }
    
    // MARK: - Private methods
    
    private func preparePlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: song.file, fileTypeHint: AVFileType.mp3.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

Additionally our methods define the transitions between the states, since we cannot play or stop the same song two times. Don't get me wrong: nothing bad will happen if we play the same song two times. However, in other use-cases triggering the same state two or more times, or triggering state `B` before triggering state `A` may cause some issues. That is why this kind of restriction was implemented when changing the states. 

The final thing that we have left to do is to actually take a look at the usage of our `PlayerContext`:

```swift
let song = Song(name: "Music", file: url)
let anotherSong = Song(name: "Another Music", file: anotherUrl)

let playerContext = PlayerContext(song: song)
playerContext.play()
playerContext.play() // intentionally called play for the second time

DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
    playerContext.stop()
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
        playerContext.play()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            playerContext.stop()
            
            playerContext.song = anotherSong
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                playerContext.play()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
                    playerContext.stop()
                }
            }
        }
    }
}
```

This pyramid-of-doom-like construction will simulate the state changes after some delays, so we will be able to practically see (or hear) how the states are changing and our implementation works. 

As a final touch, the `PlayerContext` can be wrapped into an type called `MusicPlayer` that will incapculate the context and the dependent logic related to loading songs. But we will skip the implementation details here.

## Conclusion
`State` design pattern is a great way to model states independently from each other and decouple if-else constructions, so that new states can be added/changed/removed at run-time. Also, implementing brand new states is a quite simple task: all we need to do is to implement a new method with the default implementation, provide a type that implements that method and then extend our `Context`. Also, it gives us an another great feature of the pattern: new states don't break the existing code (except the whole design was changed and the old states depend on the newly added ones).