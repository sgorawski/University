using System;
using System.Linq.Expressions;
using System.Web;
using System.Web.Mvc;

namespace ASPNET_Z6_5.Extensions
{
    public static class LoginExtensions
    {
        public static IHtmlString Login(
            this HtmlHelper htmlHelper,
            string usernameInputName,
            string passwordInputName)
        {
            var usernameInput = new TagBuilder("input");
            usernameInput.MergeAttribute("type", InputType.Text.ToString());
            usernameInput.MergeAttribute("name", usernameInputName);

            var passwordInput = new TagBuilder("input");
            passwordInput.MergeAttribute("type", InputType.Password.ToString());
            passwordInput.MergeAttribute("name", passwordInputName);

            var html = string.Join(
                Environment.NewLine,
                usernameInput.ToString(),
                passwordInput.ToString());

            return new MvcHtmlString(html);
        }

        public static IHtmlString LoginFor<TModel, TUserName, TPassword>(
            this HtmlHelper<TModel> htmlHelper,
            Expression<Func<TModel, TUserName>> usernameExpression,
            Expression<Func<TModel, TPassword>> passwordExpression)
        {
            var ue = usernameExpression.Body as MemberExpression;
            var pe = passwordExpression.Body as MemberExpression;
            return htmlHelper.Login(ue.Member.Name, pe.Member.Name);
        }
    }
}
