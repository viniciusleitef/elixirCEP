import './App.css';
import React, { useState } from 'react';

function App() {
  const [cepInput, setCepInput] = useState('');
  const [estadoInput, setEstadoInput] = useState('');
  const [cidadeInput, setCidadeInput] = useState('');
  const [ruaInput, setRuaInput] = useState('');
  const [result, setResult] = useState(null);

  const buscarCep = async () => {
    const response = await fetch(`http://localhost:4000/api/cep/${cepInput}`);
    const data = await response.json();
    setResult(data);
  };

  const buscarCepPorEndereco = async () => {
    const response = await fetch(`http://localhost:4000/api/address?estado=${estadoInput}&cidade=${cidadeInput}&rua=${ruaInput}`);
    const data = await response.json();
    setResult(data);
  };

  const renderResult = () => {
    if (result) {
      // Verifica se a resposta tem a chave 'message' ou 'error' e exibe apenas o valor correspondente
      if (result.message) {
        return <p>{result.message}</p>;
      } else if (result.error) {
        return <p style={{ color: 'red' }}>{result.error}</p>;
      }
    }
    return null;
  };

  return (
    <div>
      <h1>Buscador de CEP</h1>

      {/* Formulário para buscar por CEP */}
      <input 
        value={cepInput} 
        onChange={(e) => setCepInput(e.target.value)} 
        placeholder="Digite o CEP" 
      />
      <button onClick={buscarCep}>Buscar por CEP</button>

      {/* Formulário para buscar por endereço */}
      <h2>Ou busque pelo endereço:</h2>
      <input 
        value={estadoInput} 
        onChange={(e) => setEstadoInput(e.target.value)} 
        placeholder="Digite o estado" 
      />
      <input 
        value={cidadeInput} 
        onChange={(e) => setCidadeInput(e.target.value)} 
        placeholder="Digite a cidade" 
      />
      <input 
        value={ruaInput} 
        onChange={(e) => setRuaInput(e.target.value)} 
        placeholder="Digite a rua" 
      />
      <button onClick={buscarCepPorEndereco}>Buscar pelo Endereço</button>

      {/* Renderiza o resultado */}
      <div>
        <h2>Resultado:</h2>
        {renderResult()}
      </div>
    </div>
  );
}

export default App;
