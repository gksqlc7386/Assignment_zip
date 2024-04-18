import Foundation

let game = BaseballGame()
game.start() // BaseballGame 인스턴스를 만들고 start 함수를 구현하기

// BaseballGame.swift 파일 생성
struct BaseballGame {
    func start() {
        let answer = makeAnswer() // 정답을 만드는 함수
        
        var ball:Int = 0 //볼 값
        var strike:Int = 0 //스트라이크 값
        while true {
            print("숫자 세 자리를 입력하세요")
            let input = readLine()!
            let userAnswer = input
            //1. 정수가 아닐 경우
            for i in userAnswer {
                if i.isNumber == false {
                    print("올바르지 않은 입력값입니다.")
                    break
                }
                continue
            }
            //2.input 값이 세자리가 아닐 경우
            if userAnswer.count != 3 {
                print("올바르지 않은 입력값입니다.")
                continue
            }
            //3. input에 0이 들어갈 경우
            for i in userAnswer {
                if i == "0" {
                    print("올바르지 않은 입력값입니다.")
                }
                continue
            }
            //4. 숫자가 반복되는 경우
            if userAnswer.count != Set(userAnswer).count {
                print("올바르지 않은 입력값입니다.")
                continue
            }
            //4. 정답과 유저의 입력값을 비교하여 스트라이크/볼을 출력하기
            // 정답과 유저의 입력값 비교
            let answerArr = Array(answer)
            let userArr = Array(userAnswer)
            for i in 0..<3 {
                if answerArr[i] == userArr[i] {
                    strike += 1
                } else if answerArr.contains(userArr[i]) {
                    ball += 1
                }
            }
            // 스트라이크/볼 출력
            if strike == 3 {
                print("정답입니다!")
                break
            } else if (strike != 0) && (ball == 0) {
                print("\(strike)스트라이크")
                strike = 0
                ball = 0
            } else if (strike == 0) && (ball != 0) {
                print("\(ball)볼")
                strike = 0
                ball = 0
            } else if (strike != 0) && (ball != 0) {
                print("\(strike)스트라이크 \(ball)볼")
                strike = 0
                ball = 0
            } else if (strike == 0) && (ball == 0) {
                print("Nothing")
            }
        }
    }
    // 정답을 랜덤으로 만드는 함수
    func makeAnswer() -> String {
        var answerArr:[Int] = []
        var num:Int = 0
        while answerArr.count < 3 {
            num = Int.random(in: 1...9)
            answerArr.append(num)
            let removeDupicate = Set(answerArr)
            answerArr = Array(removeDupicate)
        }
        return String(answerArr.reduce(0, { $0 * 10 + $1 }))
    }
}


