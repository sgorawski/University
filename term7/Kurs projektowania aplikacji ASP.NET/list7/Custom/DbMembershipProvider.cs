using System.Linq;
using System.Web.Security;

namespace ASPNET_Z7
{
    public class DbMembershipProvider : MembershipProvider
    {
        private readonly StoreDataContext db = new StoreDataContext();

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
            var user = new Models.User
            {
                Name = username,
                Email = email,
                Password = Auth.CreatePassword(password)
            };
            db.Users.InsertOnSubmit(user);
            db.SubmitChanges();
            status = MembershipCreateStatus.Success;
            return new MembershipUser(
                providerName: "DbMembershipProvider",
                name: username,
                providerUserKey: providerUserKey,
                email: email,
                passwordQuestion: passwordQuestion,
                comment: "no",
                isApproved: isApproved,
                isLockedOut: false,
                creationDate: System.DateTime.Now,
                lastLoginDate: System.DateTime.Now,
                lastActivityDate: System.DateTime.Now,
                lastPasswordChangedDate: System.DateTime.Now,
                lastLockoutDate: System.DateTime.Now
            );
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
            var user = db.Users.FirstOrDefault(u => u.Name == username);
            return Auth.ValidatePassword(password, user.Password);
        }
    }
}
