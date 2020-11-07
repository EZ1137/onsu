DROP SEQUENCE REVIEWSEQ;
--DROP SEQUENCE MSGSEQ;
DROP SEQUENCE WISHSEQ;
DROP SEQUENCE VIDEOSEQ;
DROP SEQUENCE NOTICESEQ;
DROP SEQUENCE REPORTSEQ;
DROP SEQUENCE LISTENVIDEOSEQ;
DROP SEQUENCE LISTENWITHSEQ;
DROP SEQUENCE REPLY_SEQ;
DROP SEQUENCE CALENDARSEQ;
DROP SEQUENCE IMAGESEQ;
DROP SEQUENCE CLASSSEQ;
DROP SEQUENCE MEMBERSEQ;

DROP TABLE REVIEW;
--DROP TABLE MSG;
DROP TABLE WISHLIST;
DROP TABLE VIDEO;
DROP TABLE NOTICE;
DROP TABLE REPORT;
DROP TABLE LISTEN_VIDEO;
DROP TABLE LISTEN_WITH;
DROP TABLE CALENDAR;
DROP TABLE REPLY;
DROP TABLE CLASS;
DROP TABLE CLASSIMAGE;
DROP TABLE MEMBER;
DROP TABLE AUTHORITIES;

CREATE SEQUENCE MEMBERSEQ;
CREATE SEQUENCE REVIEWSEQ;
--CREATE SEQUENCE MSGSEQ;
CREATE SEQUENCE WISHSEQ;
CREATE SEQUENCE VIDEOSEQ;
CREATE SEQUENCE CLASSSEQ;
CREATE SEQUENCE NOTICESEQ;
CREATE SEQUENCE REPORTSEQ;
CREATE SEQUENCE LISTENVIDEOSEQ;
CREATE SEQUENCE LISTENWITHSEQ;
CREATE SEQUENCE CALENDARSEQ;
CREATE SEQUENCE REPLY_SEQ;
CREATE SEQUENCE IMAGESEQ;


CREATE TABLE MEMBER(
   -- 회원 번호 (PK X)
   SEQ NUMBER NOT NULL,    
   -- 회원 ID (PK)
   MEMBER_ID VARCHAR2(100) NOT NULL,
   -- 회원 Password
   MEMBER_PW VARCHAR2(100) NOT NULL,   
   -- 회원 이름
   MEMBER_NAME VARCHAR2(50) NOT NULL,
   -- 회원 성별
   MEMBER_GENDER VARCHAR2(30) NOT NULL,
   -- 회원 전화번호 (Unique)
   MEMBER_PHONE VARCHAR2(20) NOT NULL,
   -- 회원 EMAIL (Unique)
   MEMBER_EMAIL VARCHAR2(1000) NOT NULL,
   -- 회원 주소
   MEMBER_ADDR VARCHAR2(2000) NOT NULL,
   -- 회원 생일 (kakao:mmdd, naver:mm-dd, google:?, facebook:?)
   MEMBER_BIRTH VARCHAR2(20) NOT NULL,
   -- 회원 상태
   MEMBER_ROLE CHAR(8) NOT NULL,
   -- 회원 가입일자
   MEMBER_REGDATE DATE NOT NULL,
   -- 회원 탈퇴일자 (NOT NULL X)
   MEMBER_DDATE DATE,
   -- 회원 정지일자 (NOT NULL X)
   MEMBER_BDATE DATE, 
   -- 강사인증 문서
   MEMBER_DOCUMENT VARCHAR2(4000),
   --권한설정=1
   ENABLED NUMBER NULL,
   -- 회원 ID : PK
   CONSTRAINT ID_MEMBER_PK PRIMARY KEY(MEMBER_ID), 
   -- 회원 성별 : CHK(F:emale, M:ale)
   CONSTRAINT MEMBER_GENDER_MEMBER_CHK CHECK(MEMBER_GENDER IN('F','M')), 
   -- 회원 전화번호 : UQ
   CONSTRAINT PHONE_MEMBER_UNQ UNIQUE(MEMBER_PHONE), 
   -- 회원 EMAIL : UQ
   CONSTRAINT EMAIL_MEMBER_UNQ UNIQUE(MEMBER_EMAIL), 
   -- 회원 상태 : CHK( I:ntern(교생), T:eacher(강사), , D:eleted(탈퇴))
  CONSTRAINT MEMBER_ROLE_MEMBER_CHK CHECK(MEMBER_ROLE IN('S','I','T','A','D','B'))
);


SELECT * FROM MEMBER;

--관리자 계정
INSERT INTO MEMBER 
VALUES(MEMBERSEQ.NEXTVAL, 'admin', 'admin', '관리자', 'M', 'admin@onsoo.com',
   '서울 강남구 역삼동', '010-0000-0000', '1019', 'A', NULL, NULL);


   
--권한테이블 추가 
CREATE TABLE AUTHORITIES(
      MEMBER_ID  VARCHAR2(100) NOT NULL,
      AUTHORITY  VARCHAR2(20)  NOT NULL
CONSTRAINT IDX_AUTHORITIES_PK PRIMARY KEY (MEMBER_ID, AUTHORITY);
CONSTRAINT IDX_AUTHORITIES_FK0 FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (MEMBER_ID);

);

INSERT INTO AUTHORITIES (MEMBER_ID, AUTHORITY) VALUES ('admin', 'ROLE_ADMIN');
INSERT INTO AUTHORITIES (MEMBER_ID, AUTHORITY) VALUES ('admin', 'ROLE_USER');

   
CREATE TABLE CLASS(
   -- 강의 번호(PK)
   CLASS_NO NUMBER PRIMARY KEY,
   -- 강의 제목
   CLASS_TITLE VARCHAR2(1000) NOT NULL,
   -- 강사 ID
   CLASS_TEACHERID VARCHAR2(20) NOT NULL,
   -- 강사 이름
   CLASS_TEACHERNAME VARCHAR2(50) NOT NULL,
   -- 수업 타입 ('W' : 실시간  'V' : 비디오)
   CLASS_TYPE VARCHAR2(2) NOT NULL,
   -- 강의 대분류
   CLASS_BIGCATEGORY VARCHAR2(200) NOT NULL,
   -- 강의 소분류
   CLASS_SMALLCATEGORY VARCHAR2(200) NOT NULL,
   -- 강의 정보
   CLASS_INFO VARCHAR2(4000) NOT NULL,
   -- 강의 가격
   CLASS_PRICE NUMBER NOT NULL,
   -- 별점 : 리뷰 테이블에서 평균 구해서 넣기
   CLASS_STAR NUMBER NOT NULL,
   
     -- 강의 ID : FOREIGN KEY(MEMBER 테이블의 MEMBER_ID를 참조)
   FOREIGN KEY(CLASS_TEACHERID) REFERENCES MEMBER (MEMBER_ID),
   -- 강의 타입 : CHK(W:Web-rtc(실시간 과외), V:Video(동영상 강의))
   CONSTRAINT CLASS_TYPE_CHK CHECK (CLASS_TYPE IN ('W','V'))

);

INSERT INTO CLASS VALUES(CLASSSEQ.NEXTVAL, 'test', 'ss', 'ss', 'V', 'test', 'test', 'test', 3000);
INSERT INTO CLASS VALUES(CLASSSEQ.NEXTVAL, 'testk', 'ss', 'ss', 'W', 'testk', 'testk', 'testk', 7000);

SELECT * FROM CLASS;

CREATE TABLE CLASSIMAGE(
   -- 이미지 번호(PK)
   IMAGE_NO NUMBER PRIMARY KEY,
   -- 이미지 위치
   IMAGE_DIRECTORY VARCHAR2(2000) NOT NULL,
   -- 강의 번호
   CLASS_NO NUMBER NOT NULL,
   
   -- 강의 번호 : FOREIGN KEY (CLASS 테이블의 CLASS_NO 참조)
   FOREIGN KEY (CLASS_NO) REFERENCES CLASS (CLASS_NO)
   
);


CREATE TABLE REVIEW(
   -- 리뷰 번호(PK)
   REVIEW_NO NUMBER PRIMARY KEY,
   -- 작성자
   REVIEW_ID VARCHAR2(50) NOT NULL,
   -- 리뷰 내용
   REVIEW_CONTENT VARCHAR2(2000) NOT NULL,
   -- 리뷰 달린 강의 번호
   REVIEW_CLASSNO NUMBER,
   -- 별점
   REVIEW_STAR NUMBER,
   -- 작성일자
   REVIEW_DATE DATE NOT NULL,
   -- 수정일자
   REVIEW_UPDATE DATE,
   
   -- 작성자 : FOREIGN KEY(MEMBER 테이블의 MEMBER_ID를 참조)
   FOREIGN KEY(REVIEW_ID) REFERENCES MEMBER (MEMBER_ID),
   -- 강의 번호 : FOREIGN KEY(CLASS 테이블의 CLASS_NO를 참조)
   FOREIGN KEY(REVIEW_CLASSNO) REFERENCES CLASS (CLASS_NO)
);


CREATE TABLE MSG(
   -- 쪽지 번호(PK)
   MSG_NO NUMBER PRIMARY KEY,
   -- 작성자
   MSG_FROMID VARCHAR2(50) NOT NULL,
   -- 받는 사람
   MSG_TOID VARCHAR2(50) NOT NULL,
   -- 쪽지 내용
   MSG_CONTENT VARCHAR2(4000) NOT NULL,
   -- 쪽지 확인(기본 값 'N')
   MSG_READ VARCHAR2(2) NOT NULL,
   -- 보낸 날짜
   MSG_DATE DATE NOT NULL,
   
   -- 작성자 : FOREIGN KEY(MEMBER 테이블의 MEMBER_ID를 참조)
   FOREIGN KEY(MSG_FROMID) REFERENCES MEMBER (MEMBER_ID),
   -- 받는 사람 : FOREIGN KEY(MEMBER 테이블의 MEMBER_ID를 참조)
   FOREIGN KEY(MSG_TOID) REFERENCES MEMBER (MEMBER_ID),
   -- 쪽지 확인 : CHK(Y:Yes(확인), N:No(미 확인)
   CONSTRAINT MSG_READ_CHK CHECK(MSG_READ IN ('Y', 'N'))
);

CREATE TABLE VIDEO(
   -- 비디오 번호(PK)
   VIDEO_NO NUMBER PRIMARY KEY,
   -- 비디오 이름
   VIDEO_TITLE VARCHAR2(1000) NOT NULL,
   -- 비디오 재생 시간
   VIDEO_RUNTIME VARCHAR2(100) NOT NULL,
   -- 비디오 위치
   VIDEO_DIRECTORY VARCHAR2(2000) NOT NULL,
   -- 강의 번호
   CLASS_NO NUMBER NOT NULL,
   
   -- 강의 번호 : FOREIGN KEY (CLASS 테이블의 CLASS_NO 참조)
   FOREIGN KEY (CLASS_NO) REFERENCES CLASS (CLASS_NO)

);


CREATE TABLE NOTICE(
   
-- 공지사항 번호(PK)
   NOTICE_NO NUMBER PRIMARY KEY,
   -- 공지사항 제목
   NOTICE_TITLE VARCHAR2(1000) NOT NULL,
   -- 공지사항 내용
   NOTICE_CONTENT VARCHAR2(4000) NOT NULL,
   -- 공지 날짜
   NOTICE_REGDATE DATE NOT NULL
   
);

CREATE TABLE REPORT(
   -- 신고 번호(PK)
   REPORT_NO NUMBER PRIMARY KEY,
   -- 신고 내용
   REPORT_CONTENT VARCHAR2(4000) NOT NULL,
   -- 신고일
   REPORT_DATE DATE NOT NULL,
   -- 첨부파일
   REPORT_FILENAME VARCHAR2(100),
   -- 신고 한 사람
   REPORT_ID VARCHAR2(20) NOT NULL,
   -- 신고 받은 사람
   REPORT_IDED VARCHAR2(20) NOT NULL,
   -- 신고 카테고리
   REPORT_CATEGORY VARCHAR2(2) NOT NULL,

   -- 신고 받은 사람 : FOREIGN KEY (MEMBER 테이블의 MEMBER_ID를 참조)
   FOREIGN KEY (REPORT_IDED) REFERENCES MEMBER (MEMBER_ID)
   -- 신고 카테고리 : CHK(B:Blame(욕설/비방), T:Time(시간 미준수), S:Sexual(음란), Q:Quality(질이 떨어짐), P:Privacy(개인정보를 물어봄))
   CONSTRAINT REPORT_CATEGORY_CHK CHECK (REPORT_CATEGORY IN ('B', 'T', 'S', 'Q', 'P'))
);


CREATE TABLE LISTEN_VIDEO(
   -- 수강 번호(PK)
   LISTEN_VNO NUMBER PRIMARY KEY,
   -- 수강 하는 사람
   LISTEN_VMEMBERID VARCHAR2(20) NOT NULL,
   -- 수강 강의 번호
   LISTEN_VCLASSNO NUMBER NOT NULL,
   -- 수강 시작일
   LISTEN_VSTARTDATE DATE NOT NULL,
   -- 수강 강의 제목
   LISTEN_VCLASSTITLE VARCHAR2(1000) NOT NULL,
   
   -- 수강 하는 사람 : FOREIGN KEY(MEMBER 테이블의 MEMBER_ID 참조)
   FOREIGN KEY (LISTEN_VMEMBERID) REFERENCES MEMBER (MEMBER_ID),
   -- 수강 강의 번호 : FOREIGN KEY(CLASS 테이블의 CLASS_NO 참조)
   FOREIGN KEY (LISTEN_VCLASSNO) REFERENCES CLASS (CLASS_NO),
   -- 수강 강의 제목 : FOREIGN KEY(CLASS 테이블의 CLASS_TITLE 참조)
   FOREIGN KEY (LISTEN_VCLASSTITLE) REFERENCES CLASS (CLASS_TITLE)
);

INSERT INTO LISTEN_VIDEO VALUES (LISTENVIDEOSEQ.NEXTVAL, 'dd', 1, SYSDATE, 'test');


CREATE TABLE LISTEN_WITH(
   -- 수강 번호(PK)
   LISTEN_WNO NUMBER PRIMARY KEY,
   -- 수강 하는 사람
   LISTEN_WMEMBERID VARCHAR2(20) NOT NULL,
   -- 수강 강의 번호
   LISTEN_WCLASSNO NUMBER NOT NULL,
   -- 수강 횟수
   LISTEN_WCOUNT NUMBER NOT NULL,
    -- 수강 강의 제목
   LISTEN_WCLASSTITLE VARCHAR2(1000) NOT NULL,
   
   -- 수강 하는 사람 : FOREIGN KEY(MEMBER 테이블의 MEMBER_ID 참조)
   FOREIGN KEY (LISTEN_WMEMBERID) REFERENCES MEMBER (MEMBER_ID),
   -- 수강 강의 번호 : FOREIGN KEY(CLASS 테이블의 CLASS_NO 참조)
   FOREIGN KEY (LISTEN_WCLASSNO) REFERENCES CLASS (CLASS_NO),
   -- 수강 강의 제목 : FOREIGN KEY(CLASS 테이블의 CLASS_TITLE 참조)
   FOREIGN KEY (LISTEN_WCLASSTITLE) REFERENCES CLASS (CLASS_TITLE)
);

INSERT INTO LISTEN_WITH VALUES (LISTENWITHSEQ.NEXTVAL, 'dd', 2, 5, 'testk');


SELECT * FROM LISTEN_VIDEO;
SELECT * FROM LISTEN_WITH;


CREATE TABLE CALENDAR (
   -- 일정 번호
   CALENDAR_NO NUMBER PRIMARY KEY,
   -- 일정 제목
   CALENDAR_TITLE VARCHAR2(1000) NOT NULL,
   -- 일정 내용
   CALENDAR_CONTENT VARCHAR2(4000) NOT NULL,
   -- 일정 예정 시간
   CALENDAR_MDATE VARCHAR2(20) NOT NULL,
   -- 일정 등록 시간
   CALENDAR_REGDATE DATE NOT NULL,
   -- 등록 ID(MEMBER 테이블 참조)
   MEMBER_ID VARCHAR2(20) REFERENCES MEMBER (MEMBER_ID)
);

SELECT * FROM CALENDAR


CREATE TABLE REPLY(
	--댓글번호
   REPLY_NO NUMBER NOT NULL,
   --아이디
   REPLY_ID VARCHAR2(100) NOT NULL,
   --댓글남길 해당글의 번호
   REPLY_BOARDNO NUMBER NOT NULL,
   --댓글의 제목 및 내용
   REPLY_TITLE VARCHAR2(1000) NOT NULL, --댓글 내용
   --댓글 작성 날짜
   REPLY_REGDATE DATE NOT NULL,
   
   CONSTRAINT REPLY_NO_PK PRIMARY KEY(REPLY_NO),
   FOREIGN KEY (REPLY_ID) REFERENCES MEMBER (MEMBER_ID) ON DELETE CASCADE,
   FOREIGN KEY (REPLY_BOARDNO) REFERENCES FREE(FREE_SEQ) ON DELETE CASCADE

)



--CREATE TABLE WISHLIST(
--   -- 찜 번호(PK)
--   WISH_NO NUMBER PRIMARY KEY,
--   -- 찜한 사람
--   WISH_MEMBERID VARCHAR2(50) NOT NULL,
--   -- 찜 강의 번호
--   WISH_CLASSNO NUMBER NOT NULL,
--   
--   -- 찜한 사람 : FOREIGN KEY(MEMBER 테이블의 MEMBER_ID 참조)
--   FOREIGN KEY (WISH_MEMBERID) REFERENCES MEMBER (MEMBER_ID),
--   -- 찜 강의 번호 : FOREIGN KEY(CLASS 테이블의 CLASS_NO 참조)
--   FOREIGN KEY (WISH_CLASSNO) REFERENCES CLASS (CLASS_NO);
--)













