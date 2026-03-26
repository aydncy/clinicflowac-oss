
import { useEffect, useState } from 'react'

function PatientForm() {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [patients, setPatients] = useState([])

  const load = async () => {
    const res = await fetch('/api/patient')
    const json = await res.json()
    if (json.ok) setPatients(json.data)
  }

  useEffect(() => { load() }, [])

  const submit = async () => {
    await fetch('/api/patient', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, email })
    })
    setName('')
    setEmail('')
    load()
  }

  return (
    <div style={{ marginTop: 40 }}>
      <h2>Add Patient</h2>
      <input placeholder="Name" value={name} onChange={e => setName(e.target.value)} />
      <input placeholder="Email" value={email} onChange={e => setEmail(e.target.value)} />
      <button onClick={submit}>Add</button>

      <h3>Patients</h3>
      <ul>
        {patients.map(p => (
          <li key={p.id}>{p.name} - {p.email}</li>
        ))}
      </ul>
    </div>
  )
}

export default function Wrapper() {
  return <PatientForm />
}

async function addPatient() {
  await fetch('/api/patient', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({ name: 'Test', email: 'test@test.com' })
  })
}

async function loadPatients() {
  const res = await fetch('/api/patient')
  const json = await res.json()
  console.log(json)
}

<button onClick={addPatient}>Add Test Patient</button>
<button onClick={loadPatients}>Load Patients</button>

