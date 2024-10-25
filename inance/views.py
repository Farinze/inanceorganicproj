from django.shortcuts import render

# Create your views here.
def about(request):

    return render(request, 'inance/about.html')

def contact(request):

    return render(request, 'inance/contact.html')

def service(request):

    return render(request, 'inance/service.html')