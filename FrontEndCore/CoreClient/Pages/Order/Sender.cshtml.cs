using System.Threading.Tasks;
using CoreClient.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CoreClient.Pages.Order
{
  public class SenderModel : PageModel
  {
    [BindProperty]
    public Customer Sender { get; set; }
    public void OnGet()
    {
    }

    public async Task<IActionResult> OnPostAsync()
    {

      return RedirectToPage("Receiver", new {sender = Sender});
    }
  }
}