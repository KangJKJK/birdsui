#!/bin/bash

# 환경 변수 설정
export WORK="/root/Birds-Sui"
export NVM_DIR="$HOME/.nvm"

# 색상 정의
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # 색상 초기화

echo -e "${GREEN}Birdsui 봇을 설치합니다.${NC}"
echo -e "${GREEN}스크립트작성자: https://t.me/kjkresearch${NC}"
echo -e "${GREEN}출처: https://github.com/Bachtran301/Birds-Sui${NC}"

echo -e "${CYAN}이 봇은 다음과 같은 기능을 갖고 있습니다.${NC}"
echo -e "${CYAN}웜캐칭 / 에그업그레이드/ 에그크래킹 / 각종 태스크${NC}"

echo -e "${GREEN}설치 옵션을 선택하세요:${NC}"
echo -e "${YELLOW}1. Bird 봇 새로 설치${NC}"
echo -e "${YELLOW}2. 기존정보 그대로 이용하기(재실행)${NC}"
read -p "선택: " choice

case $choice in
  1)
    echo -e "${GREEN}Bird 봇을 새로 설치합니다.${NC}"

    #필요한 패키지 설치
    echo -e "${YELLOW}시스템 업데이트 및 필수 패키지 설치 중...${NC}"
    rm -rf /root/Birds-Sui
    sudo apt update
    sudo apt install -y git
    
    # GitHub에서 코드 복사
    echo -e "${YELLOW}GitHub에서 코드 복사 중...${NC}"
    git clone https://github.com/Bachtran301/Birds-Sui.git .

    # 기존 작업 공간 확인 및 삭제, 새 작업 공간 생성 및 이동
    echo -e "${YELLOW}작업 공간 준비 중...${NC}"
    if [ -d "$WORK" ]; then
        echo -e "${YELLOW}기존 작업 공간 삭제 중...${NC}"
        rm -rf "$WORK"
    fi
    mkdir -p "$WORK"
    cd "$WORK"

    # Node.js LTS 버전 설치 및 사용
    echo -e "${YELLOW}Node.js LTS 버전을 설치하고 설정 중...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # nvm을 로드합니다
    nvm install --lts
    nvm use --lts
    npm install

    echo -e "${GREEN}여러 개의 query_id를 입력할 경우 줄바꿈으로 구분하세요.${NC}"
    echo -e "${GREEN}입력을 마치려면 엔터를 두 번 누르세요.${NC}"
    echo -e "${YELLOW}query_id를 입력하세요:${NC}"
    
    # data.txt 파일 생성 및 초기화
    {
        while IFS= read -r line; do
            [[ -z "$line" ]] && break
            echo "$line"
        done
    } > "$WORK/data.txt"

    # 사용자에게 프록시 사용 여부를 물어봅니다.
    read -p "프록시를 사용하시겠습니까? (y/n): " use_proxy
    
    if [[ "$use_proxy" == "y" || "$use_proxy" == "Y" ]]; then
        # 프록시 정보 입력 안내
        echo -e "${YELLOW}프록시 정보를 입력하세요. 입력형식: http://user:pass@ip:port${NC}"
        echo -e "${YELLOW}여러 개의 프록시는 줄바꿈으로 구분하세요.${NC}"
        echo -e "${YELLOW}입력을 마치려면 엔터를 두 번 누르세요.${NC}"

        # proxy.txt 파일 생성 및 초기화
        {
            while IFS= read -r line; do
                [[ -z "$line" ]] && break
                echo "$line"
            done
        } > "$WORK/proxy.txt"
        
        # 봇 구동
        node birds-proxy.js
    else
        node birds.js
    fi
    ;;
    
  2)
    echo -e "${GREEN}Bird 봇을 재실행합니다.${NC}"
    
    # 사용자에게 프록시 사용 여부를 물어봅니다.
    read -p "프록시를 사용하시겠습니까? (y/n): " use_proxy
    cd "$WORK"
    if [[ "$use_proxy" == "y" || "$use_proxy" == "Y" ]]; then 
        node birds-proxy.js
    else
        node birds.js
    fi
    ;;

  *)
    echo -e "${RED}잘못된 선택입니다. 다시 시도하세요.${NC}"
    ;;
esac
