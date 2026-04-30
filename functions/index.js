const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

/**
 * 이름과 생년월일을 확인하여 비밀번호를 강제로 재설정하는 함수
 * (클라이언트 SDK에서는 불가능한 Admin 권한 기능)
 */
exports.resetPasswordWithMetadata = functions.https.onCall(async (data, context) => {
  const { email, name, birthDate, newPassword } = data;

  if (!email || !name || !birthDate || !newPassword) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "필수 정보가 누락되었습니다."
    );
  }

  try {
    // 1. Firestore에서 정보 일치 여부 확인
    const userQuery = await admin
      .firestore()
      .collection("users")
      .where("email", "==", email)
      .where("name", "==", name)
      .where("birthDate", "==", birthDate)
      .limit(1)
      .get();

    if (userQuery.empty) {
      throw new functions.https.HttpsError(
        "not-found",
        "일치하는 사용자 정보를 찾을 수 없습니다."
      );
    }

    const userDoc = userQuery.docs[0];
    const uid = userDoc.id;

    // 2. Firebase Auth에서 비밀번호 업데이트
    await admin.auth().updateUser(uid, {
      password: newPassword,
    });

    // 3. (선택 사항) Firestore의 updatedAt 갱신
    await userDoc.ref.update({
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, message: "비밀번호가 성공적으로 재설정되었습니다." };
  } catch (error) {
    console.error("Password reset error:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});
