
<!DOCTYPE html>
<!-- saved from url=(0044)https://doctolib.github.io/job-applications/ -->
<html lang="en-US"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="./Technical Test @ Doctolib _ job-applications_files/style.css">

<!-- Begin Jekyll SEO tag v2.6.1 -->
<title>Technical Test @ Doctolib | job-applications</title>
<meta name="generator" content="Jekyll v3.8.5">
<meta property="og:title" content="Technical Test @ Doctolib">
<meta property="og:locale" content="en_US">
<link rel="canonical" href="https://doctolib.github.io/job-applications/">
<meta property="og:url" content="https://doctolib.github.io/job-applications/">
<meta property="og:site_name" content="job-applications">
<script type="application/ld+json">
{"@type":"WebSite","headline":"Technical Test @ Doctolib","url":"https://doctolib.github.io/job-applications/","name":"job-applications","@context":"https://schema.org"}</script>
<!-- End Jekyll SEO tag -->

  </head>

  <body data-gr-c-s-loaded="true" cz-shortcut-listen="true">

    <header>
      <div class="container">
        <h1>job-applications</h1>
        <h2></h2>

        <section id="downloads">
          
          <a href="https://github.com/doctolib/job-applications" class="btn btn-github"><span class="icon"></span>View on GitHub</a>
        </section>
      </div>
    </header>

    <div class="container">
      <section id="main_content">
        <h1 id="technical-test--doctolib">Technical Test @ Doctolib</h1>

<p>The goal is to write an algorithm that checks the availabilities of an agenda depending of the events attached to it.
The main method has a start date for input and is looking for the availabilities of the next 7 days.</p>

<p>They are two kinds of events:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">opening</code>, are the openings for a specific day and they can be recurring week by week.</li>
  <li><code class="language-plaintext highlighter-rouge">appointment</code>, times when the doctor is already booked.</li>
</ul>

<p>Your Mission:</p>

<ul>
  <li><strong>must pass the unit tests below</strong></li>
  <li>add tests for edge cases</li>
  <li>be pragmatic about performance</li>
  <li>read our values : <a href="https://about.doctolib.fr/careers/engineering.html">careers.doctolib.fr/engineering/</a></li>
  <li><strong>SQLite compatible</strong></li>
  <li><strong>DO NOT</strong> host your project on public repositories! Just send us a Zip file containing your rails project.</li>
</ul>

<h2 id="coding-in-ruby">Coding in Ruby?</h2>

<ul>
  <li>Must run with <code class="language-plaintext highlighter-rouge">ruby 2.6.5</code></li>
  <li>Must run with <code class="language-plaintext highlighter-rouge">rails 6.0.2.1</code></li>
  <li>Don’t add any gems</li>
  <li>Stick to <code class="language-plaintext highlighter-rouge">event.rb</code> and <code class="language-plaintext highlighter-rouge">event_test.rb</code> files</li>
</ul>

<h3 id="to-init-the-project">To init the project:</h3>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ rails _6.0.2.1_ new doctolib-test --api --skip-action-mailer --skip-action-mailbox --skip-active-storage --skip-action-cable --skip-system-test --skip-puma
$ cd doctolib-test/
$ bundle exec rails g model event starts_at:datetime ends_at:datetime kind:string weekly_recurring:boolean --skip-fixture
$ bin/setup
</code></pre></div></div>

<h3 id="basic-unit-test">Basic unit test</h3>

<div class="language-ruby highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c1"># test/models/event_test.rb</span>

<span class="nb">require</span> <span class="s1">'test_helper'</span>

<span class="k">class</span> <span class="nc">EventTest</span> <span class="o">&lt;</span> <span class="no">ActiveSupport</span><span class="o">::</span><span class="no">TestCase</span>

  <span class="nb">test</span> <span class="s2">"one simple test example"</span> <span class="k">do</span>

    <span class="no">Event</span><span class="p">.</span><span class="nf">create</span> <span class="ss">kind: </span><span class="s1">'opening'</span><span class="p">,</span> <span class="ss">starts_at: </span><span class="no">DateTime</span><span class="p">.</span><span class="nf">parse</span><span class="p">(</span><span class="s2">"2014-08-04 09:30"</span><span class="p">),</span> <span class="ss">ends_at: </span><span class="no">DateTime</span><span class="p">.</span><span class="nf">parse</span><span class="p">(</span><span class="s2">"2014-08-04 12:30"</span><span class="p">),</span> <span class="ss">weekly_recurring: </span><span class="kp">true</span>
    <span class="no">Event</span><span class="p">.</span><span class="nf">create</span> <span class="ss">kind: </span><span class="s1">'appointment'</span><span class="p">,</span> <span class="ss">starts_at: </span><span class="no">DateTime</span><span class="p">.</span><span class="nf">parse</span><span class="p">(</span><span class="s2">"2014-08-11 10:30"</span><span class="p">),</span> <span class="ss">ends_at: </span><span class="no">DateTime</span><span class="p">.</span><span class="nf">parse</span><span class="p">(</span><span class="s2">"2014-08-11 11:30"</span><span class="p">)</span>

    <span class="n">availabilities</span> <span class="o">=</span> <span class="no">Event</span><span class="p">.</span><span class="nf">availabilities</span> <span class="no">DateTime</span><span class="p">.</span><span class="nf">parse</span><span class="p">(</span><span class="s2">"2014-08-10"</span><span class="p">)</span>
    <span class="n">assert_equal</span> <span class="s1">'2014/08/10'</span><span class="p">,</span> <span class="n">availabilities</span><span class="p">[</span><span class="mi">0</span><span class="p">][</span><span class="ss">:date</span><span class="p">]</span>
    <span class="n">assert_equal</span> <span class="p">[],</span> <span class="n">availabilities</span><span class="p">[</span><span class="mi">0</span><span class="p">][</span><span class="ss">:slots</span><span class="p">]</span>
    <span class="n">assert_equal</span> <span class="s1">'2014/08/11'</span><span class="p">,</span> <span class="n">availabilities</span><span class="p">[</span><span class="mi">1</span><span class="p">][</span><span class="ss">:date</span><span class="p">]</span>
    <span class="n">assert_equal</span> <span class="p">[</span><span class="s2">"9:30"</span><span class="p">,</span> <span class="s2">"10:00"</span><span class="p">,</span> <span class="s2">"11:30"</span><span class="p">,</span> <span class="s2">"12:00"</span><span class="p">],</span> <span class="n">availabilities</span><span class="p">[</span><span class="mi">1</span><span class="p">][</span><span class="ss">:slots</span><span class="p">]</span>
    <span class="n">assert_equal</span> <span class="p">[],</span> <span class="n">availabilities</span><span class="p">[</span><span class="mi">2</span><span class="p">][</span><span class="ss">:slots</span><span class="p">]</span>
    <span class="n">assert_equal</span> <span class="s1">'2014/08/16'</span><span class="p">,</span> <span class="n">availabilities</span><span class="p">[</span><span class="mi">6</span><span class="p">][</span><span class="ss">:date</span><span class="p">]</span>
    <span class="n">assert_equal</span> <span class="mi">7</span><span class="p">,</span> <span class="n">availabilities</span><span class="p">.</span><span class="nf">length</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre></div></div>

<h2 id="coding-in-javascript">Coding in Javascript?</h2>

<ul>
  <li>in modern JavaScript with <a href="https://www.npmjs.com/package/knex-orm">knex</a> to interact with database</li>
</ul>

<h3 id="to-init-the-project-1">To init the project:</h3>

<ol>
  <li><a href="https://doctolib.github.io/job-applications/doctolib-test.zip">Download the project</a></li>
  <li>Install <a href="https://nodejs.org/en/">node</a> and <a href="https://yarnpkg.com/en/">yarn</a></li>
  <li>Run <code class="language-plaintext highlighter-rouge">yarn &amp;&amp; yarn test</code>, focus on <code class="language-plaintext highlighter-rouge">src</code> folder, you are ready!</li>
</ol>

<h3 id="basic-unit-test-1">Basic unit test</h3>

<div class="language-javascript highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c1">// getAvailabilities.test.js</span>

<span class="k">import</span> <span class="nx">knex</span> <span class="k">from</span> <span class="dl">'</span><span class="s1">knexClient</span><span class="dl">'</span>
<span class="k">import</span> <span class="nx">getAvailabilities</span> <span class="k">from</span> <span class="dl">'</span><span class="s1">./getAvailabilities</span><span class="dl">'</span>

<span class="nx">describe</span><span class="p">(</span><span class="dl">'</span><span class="s1">getAvailabilities</span><span class="dl">'</span><span class="p">,</span> <span class="p">()</span> <span class="o">=&gt;</span> <span class="p">{</span>
  <span class="nx">beforeEach</span><span class="p">(()</span> <span class="o">=&gt;</span> <span class="nx">knex</span><span class="p">(</span><span class="dl">'</span><span class="s1">events</span><span class="dl">'</span><span class="p">).</span><span class="nx">truncate</span><span class="p">())</span>

  <span class="nx">describe</span><span class="p">(</span><span class="dl">'</span><span class="s1">simple case</span><span class="dl">'</span><span class="p">,</span> <span class="p">()</span> <span class="o">=&gt;</span> <span class="p">{</span>
    <span class="nx">beforeEach</span><span class="p">(</span><span class="k">async</span> <span class="p">()</span> <span class="o">=&gt;</span> <span class="p">{</span>
      <span class="k">await</span> <span class="nx">knex</span><span class="p">(</span><span class="dl">'</span><span class="s1">events</span><span class="dl">'</span><span class="p">).</span><span class="nx">insert</span><span class="p">([</span>
        <span class="p">{</span>
          <span class="na">kind</span><span class="p">:</span> <span class="dl">'</span><span class="s1">opening</span><span class="dl">'</span><span class="p">,</span>
          <span class="na">starts_at</span><span class="p">:</span> <span class="k">new</span> <span class="nb">Date</span><span class="p">(</span><span class="dl">'</span><span class="s1">2014-08-04 09:30</span><span class="dl">'</span><span class="p">),</span>
          <span class="na">ends_at</span><span class="p">:</span> <span class="k">new</span> <span class="nb">Date</span><span class="p">(</span><span class="dl">'</span><span class="s1">2014-08-04 12:30</span><span class="dl">'</span><span class="p">),</span>
          <span class="na">weekly_recurring</span><span class="p">:</span> <span class="kc">true</span><span class="p">,</span>
        <span class="p">},</span>
        <span class="p">{</span>
          <span class="na">kind</span><span class="p">:</span> <span class="dl">'</span><span class="s1">appointment</span><span class="dl">'</span><span class="p">,</span>
          <span class="na">starts_at</span><span class="p">:</span> <span class="k">new</span> <span class="nb">Date</span><span class="p">(</span><span class="dl">'</span><span class="s1">2014-08-11 10:30</span><span class="dl">'</span><span class="p">),</span>
          <span class="na">ends_at</span><span class="p">:</span> <span class="k">new</span> <span class="nb">Date</span><span class="p">(</span><span class="dl">'</span><span class="s1">2014-08-11 11:30</span><span class="dl">'</span><span class="p">),</span>
        <span class="p">},</span>
      <span class="p">])</span>
    <span class="p">})</span>

    <span class="nx">it</span><span class="p">(</span><span class="dl">'</span><span class="s1">should fetch availabilities correctly</span><span class="dl">'</span><span class="p">,</span> <span class="k">async</span> <span class="p">()</span> <span class="o">=&gt;</span> <span class="p">{</span>
      <span class="kd">const</span> <span class="nx">availabilities</span> <span class="o">=</span> <span class="k">await</span> <span class="nx">getAvailabilities</span><span class="p">(</span><span class="k">new</span> <span class="nb">Date</span><span class="p">(</span><span class="dl">'</span><span class="s1">2014-08-10</span><span class="dl">'</span><span class="p">))</span>
      <span class="nx">expect</span><span class="p">(</span><span class="nx">availabilities</span><span class="p">.</span><span class="nx">length</span><span class="p">).</span><span class="nx">toBe</span><span class="p">(</span><span class="mi">7</span><span class="p">)</span>
      <span class="nx">expect</span><span class="p">(</span><span class="nb">String</span><span class="p">(</span><span class="nx">availabilities</span><span class="p">[</span><span class="mi">0</span><span class="p">].</span><span class="nx">date</span><span class="p">)).</span><span class="nx">toBe</span><span class="p">(</span><span class="nb">String</span><span class="p">(</span><span class="k">new</span> <span class="nb">Date</span><span class="p">(</span><span class="dl">'</span><span class="s1">2014-08-10</span><span class="dl">'</span><span class="p">)))</span>
      <span class="nx">expect</span><span class="p">(</span><span class="nx">availabilities</span><span class="p">[</span><span class="mi">0</span><span class="p">].</span><span class="nx">slots</span><span class="p">).</span><span class="nx">toEqual</span><span class="p">([])</span>
      <span class="nx">expect</span><span class="p">(</span><span class="nb">String</span><span class="p">(</span><span class="nx">availabilities</span><span class="p">[</span><span class="mi">1</span><span class="p">].</span><span class="nx">date</span><span class="p">)).</span><span class="nx">toBe</span><span class="p">(</span><span class="nb">String</span><span class="p">(</span><span class="k">new</span> <span class="nb">Date</span><span class="p">(</span><span class="dl">'</span><span class="s1">2014-08-11</span><span class="dl">'</span><span class="p">)))</span>
      <span class="nx">expect</span><span class="p">(</span><span class="nx">availabilities</span><span class="p">[</span><span class="mi">1</span><span class="p">].</span><span class="nx">slots</span><span class="p">).</span><span class="nx">toEqual</span><span class="p">([</span><span class="dl">'</span><span class="s1">9:30</span><span class="dl">'</span><span class="p">,</span> <span class="dl">'</span><span class="s1">10:00</span><span class="dl">'</span><span class="p">,</span> <span class="dl">'</span><span class="s1">11:30</span><span class="dl">'</span><span class="p">,</span> <span class="dl">'</span><span class="s1">12:00</span><span class="dl">'</span><span class="p">])</span>
      <span class="nx">expect</span><span class="p">(</span><span class="nx">availabilities</span><span class="p">[</span><span class="mi">2</span><span class="p">].</span><span class="nx">slots</span><span class="p">).</span><span class="nx">toEqual</span><span class="p">([])</span>
      <span class="nx">expect</span><span class="p">(</span><span class="nb">String</span><span class="p">(</span><span class="nx">availabilities</span><span class="p">[</span><span class="mi">6</span><span class="p">].</span><span class="nx">date</span><span class="p">)).</span><span class="nx">toBe</span><span class="p">(</span><span class="nb">String</span><span class="p">(</span><span class="k">new</span> <span class="nb">Date</span><span class="p">(</span><span class="dl">'</span><span class="s1">2014-08-16</span><span class="dl">'</span><span class="p">)))</span>
    <span class="p">})</span>
  <span class="p">})</span>
<span class="p">})</span>
</code></pre></div></div>

      </section>
    </div>

    
  

</body></html>
