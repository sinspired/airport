const base64Encode = str => bytesToBase64(new TextEncoder().encode(str));

function bytesToBase64(bytes) {
    return btoa(new Uint8Array(bytes).reduce((data, byte) => data + String.fromCharCode(byte), ''));
  }

function getParam(params, paramName, defaultVal) {
    const val = params.get(paramName);
    if (val == null && defaultVal == null) {
        throw new Error(paramName + ' is null');
    }
    return val != null ? val : defaultVal;
}

export default {
    async fetch(request, env, ctx) {
        try {
            const url = new URL(request.url);
            const params = new URLSearchParams(url.search);
            switch (url.pathname) {
                case '/':
                case '/base64':
                    const t1 = getParam(params, 'target');
                    let c1 = await fetch(t1, {"method": "GET"}).then((res) => res.text());
                    return new Response(base64Encode(c1));
                case '/markdown':
                    const t2 = getParam(params, 'target');
                    let c2 = await fetch(t2, {"method": "GET"}).then((res) => res.text());
                    const pos = getParam(params, 'pos', 1);
                    c2 = c2.replaceAll('```\n', '```')
                    const arr = c2.split('```');
                    if (arr.length < 3) {
                        throw new Error('invalid markdown content');
                    }
                    return new Response(base64Encode(arr[pos]));
            }
        } catch (e) {
            return new Response(e.toString(), {status: 500});
        }
    },
};