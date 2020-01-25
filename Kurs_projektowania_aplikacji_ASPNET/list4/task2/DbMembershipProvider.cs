using System.Web.Security;

namespace ASPNET_Z4_2
{
    public class DbMembershipProvider : MembershipProvider
    {
        public DbMembershipProvider() { }

        public override bool EnablePasswordRetrieval => throw new System.NotImplementedException();

        public override bool EnablePasswordReset => throw new System.NotImplementedException();

        public override bool RequiresQuestionAndAnswer => throw new System.NotImplementedException();

        public override string ApplicationName { get => throw new System.NotImplementedException(); set => throw new System.NotImplementedException(); }

        public override int MaxInvalidPasswordAttempts => throw new System.NotImplementedException();

        public override int PasswordAttemptWindow => throw new System.NotImplementedException();

        public override bool RequiresUniqueEmail => throw new System.NotImplementedException();

        public override MembershipPasswordFormat PasswordFormat => throw new System.NotImplementedException();

        public override int MinRequiredPasswordLength => throw new System.NotImplementedException();

        public override int MinRequiredNonAlphanumericCharacters => throw new System.NotImplementedException();

        public override string PasswordStrengthRegularExpression => throw new System.NotImplementedException();

        public override bool ChangePassword(string username, string oldPassword, string newPassword)
        {
            throw new System.NotImplementedException();
        }

        public override bool ChangePasswordQuestionAndAnswer(string username, string password, string newPasswordQuestion, string newPasswordAnswer)
        {
            throw new System.NotImplementedException();
        }

        public override MembershipUser CreateUser(string username, string password, string email, string passwordQuestion, string passwordAnswer, bool isApproved, object providerUserKey, out MembershipCreateStatus status)
        {
            throw new MembershipCreateUserException("I cannot into db yet");
        }

        public override bool DeleteUser(string username, bool deleteAllRelatedData)
        {
            throw new System.NotImplementedException();
        }

        public override MembershipUserCollection FindUsersByEmail(string emailToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new System.NotImplementedException();
        }

        public override MembershipUserCollection FindUsersByName(string usernameToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new System.NotImplementedException();
        }

        public override MembershipUserCollection GetAllUsers(int pageIndex, int pageSize, out int totalRecords)
        {
            throw new System.NotImplementedException();
        }

        public override int GetNumberOfUsersOnline()
        {
            throw new System.NotImplementedException();
        }

        public override string GetPassword(string username, string answer)
        {
            throw new System.NotImplementedException();
        }

        public override MembershipUser GetUser(object providerUserKey, bool userIsOnline)
        {
            throw new System.NotImplementedException();
        }

        public override MembershipUser GetUser(string username, bool userIsOnline)
        {
            throw new System.NotImplementedException();
        }

        public override string GetUserNameByEmail(string email)
        {
            throw new System.NotImplementedException();
        }

        public override string ResetPassword(string username, string answer)
        {
            throw new System.NotImplementedException();
        }

        public override bool UnlockUser(string userName)
        {
            throw new System.NotImplementedException();
        }

        public override void UpdateUser(MembershipUser user)
        {
            throw new System.NotImplementedException();
        }

        public override bool ValidateUser(string username, string password)
        {
            return username == password;
        }
    }
}