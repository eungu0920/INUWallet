//
//  DepartmentsData.swift
//  INUWallet
//
//  Created by Gray on 2023/03/31.
//

import Foundation

struct DepartmentsData {
    enum College: String {
        case humanities = "인문대학"
        case naturalScience = "자연과학대학"
        case socialScience = "사회과학대학"
        case commerceAndPublicAffairs = "글로벌정경대학"
        case engineering = "공과대학"
        case informationTechnology = "정보기술대학"
        case businessAdministration = "경영대학"
        case artsAndPhysicalEducation = "예술체육대학"
        case collegeOfEducation = "사범대학"
        case urbanScience = "도시과학대학"
        case lifeScienceAndBioengineering = "생명과학대학"
        case northeastAsianStudies = "동북아국제통상학부"
        case schoolOfLaw = "법학부"
    }
    
    struct Department {
        var college: College
        var department: [String]
    }
    
    static let list: [Department] = [
        Department(
            college: .humanities,
            department: ["국어국문학과", "독어독문학과", "일본지역문화학과", "영어영문학과", "불어불문학과", "중어중국학과"]
        ),
        Department(
            college: .naturalScience,
            department: ["수학과", "물리학과", "화학과", "패션산업학과", "해양학과"]
        ),
        Department(
            college: .socialScience,
            department: ["사회복지학과", "미디어커뮤니케이션학과", "문헌정보학과", "창의인재개발학과"]
        ),
        Department(
            college: .commerceAndPublicAffairs,
            department: ["행정학과", "정치외교학과", "경제학과", "무역학부", "소비자학과"]
        ),
        Department(
            college: .engineering,
            department: ["기계・로봇공학", "메카트로닉스공학", "전기공학과", "전자공학과", "산업경영공학과", "신소재공학과", "안전공학과", "에너지화학공학과"]
        ),
        Department(
            college: .informationTechnology,
            department: ["컴퓨터공학부", "정보통신공학과", "임베디드시스템공학과"]
        ),
        Department(
            college: .businessAdministration,
            department: ["경영학부", "세무회계학과"]
        ),
        Department(
            college: .artsAndPhysicalEducation,
            department: ["조형예술학부", "디자인학부", "공연예술학과", "체육학부", "운동건강학부"]
        ),
        Department(
            college: .collegeOfEducation,
            department: ["국어교육과", "영어교육과", "일어교육과", "수학교육과", "체육교육과", "유아교육과", "역사교육과", "윤리교육과"]
        ),
        Department(
            college: .urbanScience,
            department: ["도시행정학과", "도시공학과", "도시환경공학부", "도시건축학부"]
        ),
        Department(
            college: .lifeScienceAndBioengineering,
            department: ["생명과학부", "생명공학부"]
        ),
        Department(
            college: .northeastAsianStudies,
            department: ["동북아국제통상학부"]
        ),
        Department(
            college: .schoolOfLaw,
            department: ["법학부"]
        ),
        
    ]
}
