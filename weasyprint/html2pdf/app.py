import os, re
import shutil
import uuid

from wsgiref.simple_server import make_server
from pyramid.config import Configurator
from pyramid.response import FileResponse
from jinja2 import Environment, FileSystemLoader
from weasyprint import HTML

app_dir = os.path.dirname(os.path.realpath(__file__))
res_dir = os.path.join(app_dir, 'resources')
css_dir = os.path.join(res_dir, 'css')
tpl_dir = os.path.join(res_dir, 'templates')

def PurgePDF(dir):
    for f in os.listdir(dir):
        if re.search('\.pdf$', f):
            os.remove(os.path.join(dir, f))

def GetTpl(name):
    pkg_dir = os.path.dirname(os.path.abspath(name))
    name = os.path.basename(name)
    return Environment(loader=FileSystemLoader(pkg_dir)).get_template(name)

def Index(request):
    tpl = GetTpl(tpl_dir + '/index.tpl')

    for d, dirs, files in os.walk(css_dir):
        break

    html_tpl = {'options': dict.fromkeys(dirs)}
    with open(res_dir + "/index.html", "w") as fn:
        fn.write(tpl.render(html_tpl))

    return FileResponse(res_dir + "/index.html", request=request, content_type='text/html', content_encoding='UTF-8')

def Html2Pdf(request):
    tfile_path = os.path.join(css_dir, request.matchdict['code'])
    file_path = os.path.join(tfile_path, '%s.html' % uuid.uuid4())
    tmp_file_path = file_path + '~'

    PurgePDF(tfile_path)

    input_file = request.POST['fileselect'].file
    input_file.seek(0)

    with open(tmp_file_path, "wb") as output_file:
        shutil.copyfileobj(input_file, output_file)

    os.rename(tmp_file_path, file_path)

    HTML(filename=file_path).write_pdf(file_path + '.pdf')
    return FileResponse(file_path + '.pdf', request=request, content_type='application/pdf')

def main():
    with Configurator() as conf:
        conf.add_route('index', '/')
        conf.add_view(Index, route_name='index')

        conf.add_route('html2pdf', '/html2pdf/{code}')
        conf.add_view(Html2Pdf, route_name='html2pdf')

        app = conf.make_wsgi_app()

    server = make_server('0.0.0.0', 4652, app)
    server.serve_forever()

if __name__ == '__main__':
    main()
