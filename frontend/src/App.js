import logo from './logo.svg';
import './App.css';
import Navbar from './components/Navbar';
import HeroSection from './components/Herosection';
import ProductCard from './components/Card';
import ShowCard from './components/Showcards.js';

function App() {
  return (
    <>
    <Navbar />
    <HeroSection />
    <ShowCard />
    </>
  );
}

export default App;
