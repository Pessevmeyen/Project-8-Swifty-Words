//
//  ViewController.swift
//  Project8
//
//  Created by Furkan Eruçar on 10.04.2022.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView() // UIView is the parent class of all of UIKit’s view types: labels, buttons, progress views, and more.
        view.backgroundColor = .white
        
        // more code to come! // Here, though, we’re going to be adding lots of child views and positioning them by hand, so we need a big, empty canvas to work with.
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false // Constraints'leri kendimiz yapacağımız için false dedik.
        scoreLabel.textAlignment = .right // Sağda olacak
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        // Next we’re going to add the clues and answers labels. This will involve similar code to the score label, except we’re going to set two extra properties: font and numberOfLines. The font property describes what kind of text font is used to render the label, and is provided as a dedicated type that describes a font face and size: UIFont. numberOfLines is an integer that sets how many lines the text can wrap over, but we’re going to set it to 0 – a magic value that means “as many lines as it takes.”
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false // The only new part is setting isUserInteractionEnabled to false, which is what stops the user from activating the text field and typing into it.
        view.addSubview(currentAnswer)
        
        
        /* To create a UIButton in code you need to know two things:
         
         1. Buttons have various built-in styles, but the ones you’ll most commonly use are .custom and .system. We want the default button style here, so we’ll use .system.
         2. We need to use setTitle() to adjust the title on the button, just like we did with setImage() in project 2. */
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside) // Direk StoryBoard'dan button oluşturmadığımız için bu button'ları button olarak tanımlamamızl lazım. So, altogether that line means “when the user presses the submit button, call submitTapped() on the current view controller.”
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside) //
        view.addSubview(clear)
        
        
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView) // As this thing is the last view in our view (excluding the buttons inside it, but they don’t play a part in our Auto Layout constraints), we need to give it more constraints so that Auto Layout knows our hierarchy is complete:
        
        
        
        
        
        NSLayoutConstraint.activate([ // This is done using the NSLayoutConstraint.activate() method, which accepts an array of constraints. It will put them all together at once, so we’ll be adding more constraints to this call over time.
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor), // view.layoutMarginsGuide – that will make the score label have a little distance from the right edge of the screen. topAnchor: pin to the top of the layout margins.
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor), // scoreLabel appear at tıo right corner on screen
            
            /* The tops of the clues and answers labels will be pinned to the bottom of the score label.
               The clues label will be pinned to the leading edge of the screen, indented by 100 points so that it looks neater.
               The clues label will have a width anchor set to 0.6 of the width of the main view, so that it takes up 60% of the screen. We need to subtract 100 from this to account for the indent.
               The answers label will be pinned to the trailing edge of the screen, then also indented by 100 points to match the clues label.
               The answers label will have a width anchor of 0.4 of the width of the main view, so that it takes up the remaining 40% of the screen. Again, that needs to have 100 taken away to account for the indent.
               Finally, we’re going to make the height of the answers label match the height of the clues label. */
        
            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            
            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            
            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            
            
            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            
            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            
            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            
            
            // As for constraints, we’re going to make this text field centered in our view, but only 50% its width – given how many characters it will hold, this is more than enough. We’re also going to place it below the clues label, with 20 points of spacing so the two don’t touch.
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            
            
            /* In terms of the constraints to add for those buttons, they need three each:
             
             One to set their vertical position. For the submit button we’ll be using the bottom of the current answer text field, but for the clear button we’ll be setting its Y anchor so that its stays aligned with the Y position of the submit button. This means both buttons will remain aligned even if we move one.
             We’re going to center them both horizontally in our main view. To stop them overlapping, we’ll subtract 100 from the submit button’s X position, and add 100 to the clear button’s X position. “100” isn’t any sort of special number – you can experiment with different values and see what looks good to you.
             We’re going to force both buttons to have a height of 44 points. iOS likes to make its buttons really small by default, but at the same time Apple’s human interface guidelines recommends buttons be at least 44x44 so they can be tapped easily. */
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            
            /* We’re going to give it a width and height of 750x320 so that it precisely contains the buttons inside it.
             It will be centered horizontally.
             We’ll set its top anchor to be the bottom of the submit button, plus 20 points to add a little spacing.
             We’ll pin it to the bottom of our layout margins, -20 so that it doesn’t run quite to the edge. */
            
            buttonView.widthAnchor.constraint(equalToConstant: 750),
            buttonView.heightAnchor.constraint(equalToConstant: 320),
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
             // more constraints to be added here!
            
            
        ])
        
        // set some values for the width and height of each button
        let width = 150 // Set constants to represent the width and height of our buttons for easier reference.
        let height = 80
        
        // create 20 buttons as a 4x5 grid
        for row in 0..<4 { // Loop through rows 0, 1, 2, and 3.
            for col in 0..<5 { // Loop through columns 0, 1, 2, 3, and 4.
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36) // Create a new button with a nice and large font – we can adjust the font of a button’s label using its titleLabel property.
                
                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height) // Calculate the X position of the button as being our column number multiplied by the button width. Calculate the Y position of the button as being our row number multiplied by the button height.
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonView.addSubview(letterButton) // Add the button to our buttonsView rather than the main view.
                
                // and also to our letterButtons array
                letterButtons.append(letterButton) // As a bonus, we’re going to add each button to our letterButtons array as we create them, so that we can control them later in the game.
                
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadLevel()
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        
        guard let buttonTitle = sender.titleLabel?.text else { return } // It adds a safety check to read the title from the tapped button, or exit if it didn’t have one for some reason.
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle) // Appends that button title to the player’s current answer.
        activatedButtons.append(sender) // Appends the button to the activatedButtons array // The activatedButtons array is being used to hold all buttons that the player has tapped before submitting their answer. This is important because we're hiding each button as it is tapped, so if the user taps "Clear" we need to know which buttons are currently in use so we can re-show them.
        sender.isHidden = true // Hides the button that was tapped.
        //
        
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) { // This method will use firstIndex(of:) to search through the solutions array for an item and, if it finds it, tells us its position. Remember, the return value of firstIndex(of:) is optional so that in situations where nothing is found you won't get a value back – we need to unwrap its return value carefully.
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n") // You've already learned how to use components(separatedBy:) to split text into an array, and now it's time to meet its counterpart: joined(separator:). This makes an array into a single string, with each array element separated by the string specified in its parameter.
            
            currentAnswer.text = ""
            score += 1
            
//            if sender.tag != solutionPosition {
//                let ac = UIAlertController(title: "You are Wrong!", message: nil, preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
//                present(ac, animated: true)
//            }
            
            if score % 7 == 0 { // Swift has a division remainder operator, %, that tells us what number remains when you divide one number evenly by another – that’s perfect here.
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
        
    }
    
    func levelUp(action: UIAlertAction) { // As you can see, that code clears out the existing solutions array before refilling it inside loadLevel(). Then of course you'd need to create level2.txt, level3.txt and so on.
        level += 1 // Add 1 to level.
        solutions.removeAll(keepingCapacity: true) // Remove all items from the solutions array.
        
        loadLevel() // Call loadLevel() so that a new level file is loaded and shown.
        
        for btn in letterButtons { // Make sure all our letter buttons are visible.
            btn.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            btn.isHidden = false
        }
        
        activatedButtons.removeAll()
        
    }
    
    /* We’ll fill them in later, but first let’s focus on loading level data into the game. We're going to isolate level loading into a single method, called loadLevel(). This needs to do two things:
     
     Load and parse our level text file in the format I showed you earlier.
     Randomly assign letter groups to buttons.
     In project 5 you already learned how to create a String using contentsOf to load files from disk, and we'll be using that to load our level. In that same project you learned how to use components(separatedBy:) to split up a string into an array, and we'll use that too.

     We'll also need to use Swift’s array shuffling code that we've used before. But there are some new things to learn, honest!

     First, we'll be using the enumerated() method to loop over an array. We haven't used this before, but it's helpful because it passes you each object from an array as part of your loop, as well as that object's position in the array.

     There's also a new string method to learn, called replacingOccurrences(). This lets you specify two parameters, and replaces all instances of the first parameter with the second parameter. We'll be using this to convert "HA|UNT|ED" into HAUNTED so we have a list of all our solutions.

     Before I show you the code, watch out for how I use the method's three variables: clueString will store all the level's clues, solutionString will store how many letters each answer is (in the same position as the clues), and letterBits is an array to store all letter groups: HA, UNT, ED, and so on.
     */
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") { // First, the method uses url(forResource:) and contentsOf to find and load the level string from our app bundle. String interpolation is used to combine "level" with our current level number, making "level1.txt".
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n") // The text is then split into an array by breaking on the \n character (that's line break, remember),
                lines.shuffle() // then shuffled so that the game is a little different each time.
                
                for (index, line) in lines.enumerated() { // Our loop uses the enumerated() method to go through each item in the lines array. This is different to how we normally loop through an array, but enumerated() is helpful here because it tells us where each item was in the array so we can use that information in our clue string. In the code above, enumerated() will place the item into the line variable and its position into the index variable.
                    let parts = line.components(separatedBy: ": ") // e already split the text up into lines based on finding \n, but now we split each line up based on finding :, because each line has a colon and a space separating its letter groups from its clue.
                    let answer = parts[0] // We put the first part of the split line into answer
                    let clue = parts[1] // and the second part into clue, for easier referencing later.
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "") // Next comes our new string method call, replacingOccurrences(of:). We're asking it to replace all instances of | with an empty string, so HA|UNT|ED will become HAUNTED.
                    solutionString += "\(solutionWord.count) letters\n" // We then use count to get the length of our string then use that in combination with string interpolation to add to our solutions string.
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|") // Finally, we make yet another call to components(separatedBy:) to turn the string "HA|UNT|ED" into an array of three elements, then add all three to our letterBits array.
                    letterBits += bits
                }
            }
        }
        
        // Now configure the buttons and labels. This needs to set the cluesLabel and answersLabel text, shuffle up our buttons, then assign letter groups to buttons.
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines) // There's a new string method to introduce: trimmingCharacters(in:) removes any letters you specify from the start and end of a string.
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines) // It's most frequently used with the parameter .whitespacesAndNewlines, which trims spaces, tabs and line breaks, and we need exactly that here because our clue string and solutions string will both end up with an extra line break.
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count { // That loop will count from 0 up to but not including the number of buttons, which is useful because we have as many items in our letterBits array as our letterButtons array. Looping from 0 to 19 (inclusive) means we can use the i variable to set a button to a letter group.
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
    }
    
}

