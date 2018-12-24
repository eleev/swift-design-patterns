import Foundation
import AVFoundation

// WARNING: Before proceeding please add two .mp3 files at the `Resources` folder of this .playground page (by clicking CMD+1 and unfolding the Resources directory). One file should be named `anotherSoundName.mp3` and an another one is `soundName.mp3`. You need to do that in order to be able to fully interact with the presented development here.

protocol Playable {
    var player: AVAudioPlayer { get set }
}

protocol PlayerState {
    func prepare()
    func play()
    func stop()
}

extension PlayerState {
    func prepare()  { /* empty implementation */ }
    func play()     { /* empty implementation */ }
    func stop()     { /* empty implementation */ }
}

struct PrepareState: PlayerState, Playable {
    
    // MARK: - Conformance to Playable protocol
    
    var player: AVAudioPlayer
    
    // MARK: - Conformance to PlayerState protocol
    
    func prepare() {
        print("IdleState -> idle")
        player.prepareToPlay()
    }
}

struct PlayState: PlayerState, Playable {
    
    // MARK: - Conformance to Playable protocol
    
    var player: AVAudioPlayer
    
    // MARK: - Conformance to PlayerState protocol
    
    func play() {
        print("PlayState -> play")
        player.play()
    }
}

struct StopState: PlayerState, Playable {
    
    // MARK: - Conformance to Playable protocol
    
    var player: AVAudioPlayer
    
    // MARK: - Conformance to PlayerState protocol
    
    func stop() {
        print("StopState -> stop")
        player.stop()
    }
}

class Song {
    private(set) var name: String
    private(set) var file: URL
    
    init(name: String, file: URL) {
        self.name = name
        self.file = file
    }
}

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

//: Usage :

guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else {
    fatalError("Could not find an .mp3 resource in the specified Bundle or resource name")
}

guard let anotherUrl = Bundle.main.url(forResource: "anotherSoundName", withExtension: "mp3") else {
    fatalError("Could not find an .mp3 resource in the specified Bundle or resource name")
}


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


// In order to run indefinetley we need to tell the Playgrounds that we need indefinite execution
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
