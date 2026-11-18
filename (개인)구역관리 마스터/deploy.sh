#!/usr/bin/env bash
# ==============================================================================
# 구역 관리 마스터 Pro - Firebase Hosting 원스톱 배포 스크립트
# ==============================================================================

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "========================================================"
echo "🚀 구역 관리 마스터 Firebase 호스팅 배포를 시작합니다."
echo "프로젝트 ID: member-management-master"
echo "========================================================"

# 1. index.html과 Index.html 동기화 보장
if [ -f "Index.html" ]; then
    cp -f "Index.html" "index.html"
    echo "✅ Index.html -> index.html 동기화 완료"
fi

# 2. Firebase CLI 감지
FIREBASE_CMD=""
if command -v firebase >/dev/null 2>&1; then
    FIREBASE_CMD="firebase"
elif command -v npx >/dev/null 2>&1; then
    FIREBASE_CMD="npx -y firebase-tools"
else
    # 일반적인 글로벌 npm/nvm/brew 경로 탐색
    for candidate in \
        "$HOME/.nvm/versions/node/"*"/bin/firebase" \
        "/usr/local/bin/firebase" \
        "/opt/homebrew/bin/firebase" \
        "$HOME/.npm-global/bin/firebase"; do
        if [ -x "$candidate" ]; then
            FIREBASE_CMD="$candidate"
            break
        fi
    done
fi

if [ -z "$FIREBASE_CMD" ]; then
    echo "⚠️  Firebase CLI가 시스템에 설치되어 있지 않습니다."
    echo ""
    echo "아래 명령어 중 하나를 터미널에서 실행하여 Firebase CLI를 설치해주세요:"
    echo "  1) npm이 설치된 경우: npm install -g firebase-tools"
    echo "  2) Homebrew가 설치된 경우: brew install firebase-cli"
    echo "  3) 독립형 바이너리 설치(Mac): curl -sL https://firebase.tools | bash"
    echo ""
    echo "설치 완료 후 다시 ./deploy.sh 를 실행하시면 즉시 배포됩니다."
    exit 1
fi

echo "🔍 Firebase CLI 발견: $FIREBASE_CMD"

# 3. 로그인 및 프로젝트 배포
echo "📡 Firebase 프로젝트 배포 중..."
$FIREBASE_CMD deploy --only hosting --project member-management-master

echo ""
echo "========================================================"
echo "🎉 배포가 성공적으로 완료되었습니다!"
echo "🌐 접속 URL: https://member-management-master.web.app"
echo "🌐 보조 URL: https://member-management-master.firebaseapp.com"
echo "========================================================"
