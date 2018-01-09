using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CoreClient.Pages
{
  public class LoginModel : PageModel
  {
    public string UserName { get; set; }
    public string Password { get; set; }

    public void OnGet()
    {
    }

    public async Task<IActionResult> OnPostAsync()
    {
      return RedirectToPage("/Index");
    }
  }
}