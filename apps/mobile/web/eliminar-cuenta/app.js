// Página pública de eliminación de cuenta (ADR-0049). Archivo aparte: compatible con una CSP sin 'unsafe-inline'.
(function () {
  var api = (window.SISI_CONFIG && window.SISI_CONFIG.apiUrl) || '';
  var phoneForm = document.getElementById('step-phone');
  var codeForm = document.getElementById('step-code');
  var phoneInput = document.getElementById('phone');
  var codeInput = document.getElementById('code');
  var phone = '';

  function show(el, text, kind) { el.textContent = text; el.className = 'msg' + (kind ? ' ' + kind : ''); }
  function post(path, body) {
    return fetch(api + path, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) })
      .then(function (res) {
        if (res.status === 202 || res.status === 204) return null;
        return res.json().catch(function () { return {}; }).then(function (b) {
          throw new Error(b.message || 'No se pudo completar. Intenta de nuevo en unos minutos.');
        });
      });
  }

  phoneForm.addEventListener('submit', function (e) {
    e.preventDefault();
    var msg = document.getElementById('msg-phone');
    phone = phoneInput.value.replace(/\D/g, '');
    if (!/^[67]\d{7}$/.test(phone)) { show(msg, 'Escribe tu celular de 8 dígitos (empieza con 6 o 7).', 'error'); return; }
    phoneForm.querySelector('button').disabled = true;
    post('/account-deletion/code', { phone: phone })
      .then(function () {
        show(msg, 'Si el número tiene una cuenta, te enviamos un código por SMS.', 'ok');
        codeForm.hidden = false;
        codeInput.focus();
      })
      .catch(function (err) { show(msg, err.message, 'error'); })
      .then(function () { phoneForm.querySelector('button').disabled = false; });
  });

  codeForm.addEventListener('submit', function (e) {
    e.preventDefault();
    var msg = document.getElementById('msg-code');
    var code = codeInput.value.replace(/\D/g, '');
    if (code.length !== 6) { show(msg, 'El código tiene 6 dígitos.', 'error'); return; }
    codeForm.querySelector('button').disabled = true;
    post('/account-deletion', { phone: phone, code: code })
      .then(function () {
        phoneForm.hidden = true;
        codeForm.hidden = true;
        document.getElementById('done').hidden = false;
      })
      .catch(function (err) { show(msg, err.message, 'error'); codeForm.querySelector('button').disabled = false; });
  });
})();
