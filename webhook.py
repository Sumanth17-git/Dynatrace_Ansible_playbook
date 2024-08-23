from flask import Flask, request, jsonify
import os

app = Flask(__name__)

@app.route('/run-playbook', methods=['POST'])
def run_playbook():
    data = request.json

    target_hostname = data.get('target_hostname')
    service_name = data.get('service_name')

    if not target_hostname or not service_name:
        return jsonify({'error': 'Missing target_hostname or service_name'}), 400

    command = f'ansible-playbook /path/to/restart_process.yml --extra-vars "target_hostname={target_hostname} service_name={service_name}"'

    os.system(command)

    return jsonify({'message': 'Playbook executed successfully!'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
