from django.conf import settings
from django.contrib import admin
from toolbox import views as toolbox_views
from django.conf.urls import include, url
from django.views.static import serve as static_serve
from django.contrib.admin.views.decorators import staff_member_required


urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
    # This is the URL Varnish will ping to check the server health.
    url(r'^app_status/$', toolbox_views.app_status, name='status'),
]

if settings.DEBUG:
    urlpatterns += [
        url(r'^static/(?P<path>.*)$', static_serve, {
            'document_root': settings.STATIC_ROOT,
            'show_indexes': True,
        }),
        url(r'^media/(?P<path>.*)$', static_serve, {
            'document_root': settings.MEDIA_ROOT,
            'show_indexes': True,
        }),
    ]
