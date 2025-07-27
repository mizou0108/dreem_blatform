#!/bin/bash

echo "[🔍] فحص المشروع المحلي..."
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ $? -ne 0 ]; then
  echo "[❌] ليس مشروع Git!"
  exit 1
fi

# أول commit في حال لم يوجد أي
if [ -z "$(git log --oneline)" ]; then
  echo "[⚠️] لا يوجد commit... إنشاء أول commit فارغ"
  git commit --allow-empty -m "initial commit"
fi

# تغيير اسم الفرع إذا كان master
if [ "$branch" == "master" ]; then
  echo "[🔁] إعادة التسمية من master إلى main..."
  git branch -M main
  branch="main"
fi

# إضافة الريموت إذا غير موجود
if ! git remote | grep -q origin; then
  echo "[🌐] إضافة الريموت origin..."
  git remote add origin https://github.com/mizou0108/dreem_blatform.git
fi

echo "[📡] جلب التحديثات من GitHub..."
git fetch origin

echo "[📊] مقارنة التغييرات مع origin/$branch..."
diff=$(git diff origin/$branch)

if [ -n "$diff" ]; then
  echo "[⚠️] الريموت يحتوي تغييرات لم تملكها..."
  echo "هل ترغب بدمجها؟ [y/n]"
  read merge_decision
  if [ "$merge_decision" == "y" ]; then
    echo "[🔄] جاري الدمج..."
    git pull --rebase origin $branch
  else
    echo "[🚫] تم إلغاء الدمج، لم يتم الدفع."
    exit 1
  fi
fi

echo "[🚀] جاري دفع الفرع '$branch' إلى GitHub..."
git push -u origin "$branch"

echo "[✅] تم مزامنة المشروع ورفعه بنجاح!"
